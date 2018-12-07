require 'daimyo'

module Daimyo
  class Client
    include Daimyo::Config

    def initialize
      params = read_daimyo_yaml
      @client ||= BacklogKit::Client.new(
        space_id: params['space_id'],
        api_key: params['api_key'],
        top_level_domain: params['top_level_domain']
      )
    end

    def list(project_id)
      @client.get_wikis(project_id)
    end

    def export(wiki_id)
      @client.get_wiki(wiki_id)
    end

    def publish(wiki_id, wiki_name, wiki_contents)
      params = {}
      params['name'] = wiki_name
      params['content'] = wiki_contents
      @client.update_wiki(wiki_id, params)
    end
  end
end
