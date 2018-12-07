require 'daimyo'

module Daimyo
  class Export
    def initialize
      @wiki ||= Daimyo::Client.new
    end

    def run(project_id, wiki_id = nil)
      ids = select_wiki_ids(project_id)
      ids.each do |id|
        wiki = @wiki.export(id).body
        name = wiki.name
        content = wiki.content
        write_file(project_id, id, name, content)
      end
    end

    private

    def select_wiki_ids(project_id)
      @wiki.list(project_id).body.map { |w| w.id }
    end

    def write_file(project_id, id, name, content)
      path = define_directory_path(project_id, name)
      create_wiki_directory(path)
      filename = id.to_s + '_' + define_file_path(name) + '.md'
      file_path = path + '/' + filename
      File.open(file_path, 'w') do |f|
        f.puts(content.gsub("\r\n", "\n"))
      end

      original_file_path = path + '/' + '.' + filename
      File.open(original_file_path, 'w') do |f|
        f.puts(content.gsub("\r\n", "\n"))
      end
    end

    def create_wiki_directory(path)
      FileUtils.mkdir_p(path) unless FileTest.exist?(path)
      path
    end

    def define_directory_path(project_id, name)
      space = @wiki.instance_variable_get(:@client).instance_variable_get(:@space_id)
      return space + '/' + project_id unless name.include?('/')
      space + '/' + project_id + '/' + File.dirname(name) # 最後の 1 要素をファイル名とする
    end

    def define_file_path(name)
      return name unless name.include?('/')
      File.basename(name) # 最後の 1 要素をファイル名とする
    end

  end
end
