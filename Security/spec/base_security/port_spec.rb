require 'spec_helper_ssh'
require "rspec/expectations"
require 'utilities'

describe port(53) do
  it { should be_listening.with('udp') }
end

RSpec.configure do |config|
  config.after(:suite) do
    puts "after suite"
    replace_report_title
  end
end
