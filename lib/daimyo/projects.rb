require 'daimyo'

module Daimyo
  class Projects
    include Daimyo::Config

    def initialize
      params = read_daimyo_yaml
      @space = params['space_id']
    end

    def run
      puts Dir.glob("#{@space}/*")
    end
  end
end
