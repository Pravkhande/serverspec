require 'spec_helper_ssh'
require "rspec/expectations"
require 'utilities'


# This block check mode of home
describe file("/home") do
  it { should be_mode 755 }
end

RSpec.configure do |config|
  config.after(:suite) do
    replace_report_title
  end
end



