require 'daimyo'

module Daimyo
  class Publish < Client
    def initialize(options = nil)
      @wiki ||= Daimyo::Client.new
    end

    def search_files(project_id)
      space = @wiki.instance_variable_get(:@client).instance_variable_get(:@space_id)
      paths = Dir.glob(space + '/' + project_id  +'/**/*')

      diffy_paths = []
      paths.each do |path|
        diffy_path = []  
        if path.include?('.md')
          path_array = path.split('/')
          original_file_path = '.' + path_array[-1]
          path_array.pop
          original_path = path_array.join('/') + '/' + original_file_path
          diffy_path << original_path
        else
          diffy_path << path
        end
        diffy_path << path
        diffy_paths << diffy_path
      end
      diffy_paths
    end

    def read_file(path)
      File.open(path, 'r') do |file|
        file.read
      end
    end

    def run(project_id, dry_run)
      files = search_files(project_id)

      diff_files = []
      files.each do |file|
        if file[0].include?('.md')
          original = read_file(file[0]) 
          latest = read_file(file[1])
          diff_file = []
          if original != latest
            diff_file << file[1]
            diff_file << original
            diff_file << latest
            diff_files << diff_file
          end
        end
      end

      diff_files.each do |diff_file|
        puts diff_file[0]
        puts Diffy::Diff.new(diff_file[1], diff_file[2],
                             :include_diff_info => false).to_s(:color)

        path_array = diff_file[0].split('/')
        wiki_id = path_array[-1].split('_')[0]
        wiki_name = path_array[-1].split('_')[1].gsub(/.md/, '')
        @wiki.publish(wiki_id, wiki_name, diff_file[2]) if dry_run.nil?
      end
    end
  end
end
