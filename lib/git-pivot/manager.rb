# This class manage all input from the cli
# It passes off commands to their respective handlers
# letting you manage branches, tickets, from the cli
require 'thor'

module GitPivot
  class Manager < Thor
    include GitPivot::Shared

    desc "info", "Gives you current PivotalTracker/Github information about the current ticket."
    def info
      out GitPivot::Git.info
      out "\n"
      out GitPivot::Pivotal.info
    end
  end
end


