require 'pivotal-tracker'

# in order to configure your pivotal project, you'll need to set your Pivotal info 
# as part of your gitconfig
#
# For your generic PT info, set the following option as part of your global opts:
#   `git config --global pivotal.api-token XXX`
#
# For your project, set your PT project id:
#   `git config --local pivotal.project-id'

module GitPivot
  module Pivotal
    extend GitPivot::Shared

    class << self
      def story_id
        @story_id ||= GitPivot::Git.branch.split('-').last.to_i
      end

      def project
        @project ||= tracker.project.find GitPivot::Git.config 'pivotal.project-id'
      end

      def story
        exit out "You are not currently working on a story branch. Please checkout or start a story branch.\n" if story_id == 0
        project.stories.find(current_story)
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
      end

    end
  end
end

