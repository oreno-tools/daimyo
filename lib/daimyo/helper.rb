module Daimyo
  module Helper
    def diff_print_header(message, is_local)
      return "\e[43m" + message + "\e[0m" unless is_local
      "\e[41m" + message + "\e[0m"
    end
  end
end
