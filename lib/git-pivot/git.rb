require 'grit'

module GitPivot
  module Git
    extend GitPivot::Shared

    class << self
      def start(id, type)
        branch_name = create_branch(id, type)
        last_story(id)
        "Switched to branch #{branch_name}..."
      end

      def finish(commit)
        if has_changes? && commit
          out "Please enter your commit message: ", false
          close_commit input
        elsif has_changes?
          exit out "Please commit changes before closing ticket."
        end

        merge_branch
        out "Merged changes back to master."
      end

      def deliver
        `git push`
      end

      def config(param=nil)
        return repo.config unless param
        repo.config[param]
      end
      
      def repo
        @repo ||= Grit::Repo.new(`pwd`.strip)
      end

      def branch
        @branch ||= repo.head.name
      end

      def last_story(id=nil)
        return config['pivotal.last-story'] unless id
        config['pivotal.last-story'] = id
      end

      def info
"""
-- Git Info --
Branch name: #{branch}
"""
      end
      
      private
      def create_branch(id, type)
        name = "pt-#{type}-#{id}"       

        `git branch #{name}`
        `git checkout #{name}`
        
        name
      end

      def integration_branch
        branch = config "pivotal.integration-branch"
        branch = 'master' unless branch
      end

      # TODO: error detect
      def merge_branch
        from = branch
        `git checkout #{integration_branch}`
        `git merge #{from}`
        `git branch -d #{from}`
      end

      def close_commit(input)
        repo.commit_all(input)
      end

      def has_changes?
        !repo.status.changed.empty?
      end
    end
  end
end
