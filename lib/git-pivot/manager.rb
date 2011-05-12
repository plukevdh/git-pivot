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

    desc "start TICKET_ID", "Start a story."
    method_option :mine, type: :boolean, aliases: "-m", desc: "Will ignore ticket id and and simply grab the first in your queue"

    def start(ticket=nil)
      id, text = GitPivot::Pivotal.start(ticket, options[:mine])
      
      out text
      out "\n"
      out GitPivot::Git.start(id)
      out "\nYou are now licensed to develop. Godspeed.\n"
    end
  end
end


