require 'grit'

module GitPivot
  class Git
    class << self
      def start

      end

      def repo
        Grit::Repo.new(`pwd`.strip)
      end

      def branch
        Grit::Branch 
      end
    end
  end
end
