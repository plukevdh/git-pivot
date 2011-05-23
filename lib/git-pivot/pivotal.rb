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
        return [story.id, story.story_type "Story #{id} started..."]
      end

      def finish
        current_story

        @story.update(current_state: :finished)
        out "Marked story as finished."
      end

      def deliver
        current_story
        
        @story.update(current_state: :delivered)
        out "Marked story as delivered."
      end

      def info
        current_story
"""
-- Pivotal Info --
Name: #{@story.name}
URL: #{@story.url}
Desc: #{@story.description}
"""
      end

      private
      def tracker
        PivotalTracker::Client.token = GitPivot::Git.config 'pivotal.api-token'
        PivotalTracker::Client.use_ssl = true if GitPivot::Git.config 'pivotal.use-ssl'
      end

      def current_story_id
        @story_id ||= GitPivot::Git.last_story.to_i
      end

      def current_story
        return out "You are not currently working on a story" if current_story_id == 0
        @story ||= project.stories.find(current_story_id)
      end
    end
  end
end

