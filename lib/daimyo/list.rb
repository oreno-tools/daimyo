require 'daimyo'

module Daimyo
  class List
    include Daimyo::Helper

    def initialize
      @wiki ||= Daimyo::Client.new
    end

    def run(project_id)
      wikis = []
      res = @wiki.list(project_id)
      res.body.each do |w|
        wiki = []
        wiki << w.id
        wiki << w.name
        wiki << w.created
        wiki <<  w.updated
        wikis << wiki
      end

      output_table(wikis)
    end

    def output_table(wikis)
      table = Terminal::Table.new(:headings => ['ID',
                                                'Name',
                                                'Created',
                                                'Updated'],
                                  :rows => wikis)
      puts table
    end
  end
end
