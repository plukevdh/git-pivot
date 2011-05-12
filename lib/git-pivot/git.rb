require 'grit'

module GitPivot
  module Git
    extend GitPivot::Shared

    class << self
      def start(branch_name)
        create_branch(branch_name)
        "Switched to branch #{branch_name}..."
      end

      def finish
        if has_changes?
          out "Do you want to commit all changes automatically (y/n)? "
          if input.downcase == "y"
            out "Please enter your commit message: "
            close_commit input
          else
            out "You can add this to your commit later if you like: [Delivers: #{GitPivot::Pivotal.story_id}]"
          end
          return out "Please commit all changes before finishing."
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
        @branch = repo.head.name
      end
      
      def integration_branch
        config "pivotal.integration-branch"
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

      def merge_branch
        from = branch
        `git checkout -b #{integration_branch}`
        `git merge --no-ff #{from}`
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
