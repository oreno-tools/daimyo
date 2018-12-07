require 'daimyo'

module Daimyo
  class CLI < Thor
    desc 'version', 'version print.'
    def version
      puts Daimyo::VERSION
    end

    desc 'list', 'Listing wiki page in project.'
    option :project_id, type: :string, aliases: '-p', desc: 'Specify the project id or project key'
    def list
      raise 'Backlog プロジェクトキーを指定してください.' if options[:project_id].nil?
      d = Daimyo::List.new
      d.run(options[:project_id])
    end

    desc 'export', 'Export wiki page in project.'
    option :project_id, type: :string, aliases: '-p', desc: 'Specify the project id or project key'
    option :wiki_id, type: :string, aliases: '-i', desc: 'Specify the wiki id'
    def export
      raise 'Backlog プロジェクトキーを指定してください.' if options[:project_id].nil?
      d = Daimyo::Export.new
      d.run(options[:project_id], options[:wiki_id])
    end

    desc 'publish', 'Publish wiki page.'
    option :project_id, type: :string, aliases: '-p', desc: 'Specify the project id or project key'
    option :dry_run, type: :boolean, aliases: '-d', desc: 'Dryrun.'
    def publish
      raise 'Backlog プロジェクトキーを指定してください.' if options[:project_id].nil?
      d = Daimyo::Publish.new(options)
      d.run(options[:project_id], options[:dry_run])
    end
  end
end
