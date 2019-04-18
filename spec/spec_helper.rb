require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
end

require "bundler/setup"
require "daimyo"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  original_stdout = $stdout
  original_stderr = $stderr
  config.before(:suite) do
    $stdout = File.open(File::NULL, 'w')
    $stderr = File.open(File::NULL, 'w')
  end
  config.after(:suite) do
    $stdout = original_stdout
    $stderr = original_stderr
  end
end
