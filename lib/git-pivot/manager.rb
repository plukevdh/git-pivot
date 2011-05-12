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
      out GitPivot::Pivotal.info
    end

    desc "start TICKET_ID", "Start a story."
    method_option :mine, type: :boolean, aliases: "-m", desc: "Will ignore ticket id and and simply grab the first in your queue"
    def start(ticket=nil)
      id, text = GitPivot::Pivotal.start(ticket, options[:mine])
      
      out text
      out GitPivot::Git.start(id)
      out "You are now licensed to develop. Godspeed."
    end


    desc "finish", "Finish a story"
    method_option :commit, type: :boolean, aliases: "-c", 
      desc: "Commit all existing changes with a message (and additional [Delivers: XXX] tag)."
    def finish
      GitPivot::Pivotal.finish
      GitPivot::Git.finish(options[:commit])
      out "Story complete."
    end
  end
end


