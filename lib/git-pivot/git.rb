require 'grit'

module GitPivot
  class Git
    class << self
      def start

      end

      def repo
        @repo ||= Grit::Repo.new(`pwd`.strip)
      end

      def branch
        @branch = repo.head.name
      end

      def info
        """
        -- Git Info --
        Branch name: #{branch}
        """
      end
    end
  end
end
