require 'grit'

module GitPivot
  module Git
    extend GitPivot::Shared

    class << self
      def start(branch_name)
        create_branch(branch_name)
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

      def config(param)
        repo.config[param]
      end

      def repo
        @repo ||= Grit::Repo.new(`pwd`.strip)
      end

      def branch
        @branch ||= repo.head.name
      end
      

      def info
"""
-- Git Info --
Branch name: #{branch}
"""
      end
      
      private
      def create_branch(name)
        `git branch #{name}`
        `git checkout #{name}`
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
