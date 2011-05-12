module GitPivot
  module Shared
    def out(text, newline=true)
      $stdout.write text
      $stdout.write "\n" if newline
    end

    def input
      $stdin.gets.chomp
    end
  end
end
