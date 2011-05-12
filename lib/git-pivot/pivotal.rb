require 'pivotal-tracker'

# in order to configure your pivotal project, you'll need to set your Pivotal info 
# as part of your gitconfig
#
# For your generic PT info, set the following option as part of your global opts:
#   `git config --global pivotal.api-token XXX`
#   `git config --global pivotal.full-nam FULL NAME`
#
# For your project, set your PT project id:
#   `git config --local pivotal.project-id'

module GitPivot
  module Pivotal
    extend GitPivot::Shared

    class << self
      def project
        tracker
        @project ||= PivotalTracker::Project.find GitPivot::Git.config 'pivotal.project-id'
      end

      def user
        @user ||= GitPivot::Git.config 'pivotal.full-name'
      end

      # will ignore id if mine is true
      def start(id=nil, mine=false)
        story = (mine || id.nil?) ? project.stories.all(owned_by: user).first : project.stories.find(id)

        story.update(owned_by: user, current_state: :started)
        return ["pt-#{story.type}-#{story.id}", "Story #{id} started..."]
      end
      
      def info
        return out "No info found for Pivotal Tracker." unless story
"""
-- Pivotal Info --
Name: #{story.name}
URL: #{story.url}
Desc: #{story.description}
"""
      end

      private
      def tracker
        PivotalTracker::Client.token = GitPivot::Git.config 'pivotal.api-token'
        PivotalTracker::Client.use_ssl = true if GitPivot::Git.config 'pivotal.use-ssl'
      end

      def current_story_id
        @story_id ||= GitPivot::Git.branch.split('-').last.to_i
      end

      def current_story
        exit out "You are not currently working on a story branch. Please checkout or start a story branch.\n" if story_id == 0
        project.stories.find(story_id)
      end
    end
  end
end

