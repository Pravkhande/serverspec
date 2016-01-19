require 'spec_helper_ssh'
require "rspec/expectations"
require 'utilities'


describe group('root') do
  it { should exist }
end

RSpec.configure do |config|
  config.after(:suite) do
    replace_report_title
  end
end
