module GitPivot
  module Shared
    def out(text)
      $stdout.write text
    end

    def input
      $stdin.gets.chomp
    end
  end
end
