require 'yaml'

module Daimyo
  module Config
    def read_daimyo_yaml
      $stdout.sync = true
      begin
        YAML.load_file('.daimyo.yml')
      rescue Errno::ENOENT
        puts '.daimyo.yml が存在していません.'
        exit 1
      rescue => ex
        puts '.daimyo.yml の読み込みに失敗しました. ' + ex.message
        exit 1
      end
    end
  end
end
