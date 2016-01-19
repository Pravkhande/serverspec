require 'spec_helper_ssh'
require "rspec/expectations"
require 'utilities'


# This block check for user shadowed uid in file
describe command("awk -F: '($2 != \"x\") {print}' /etc/passwd") do
  its(:stdout) {should eq ""}
end


# This block check for content in file
describe file('/etc/login.defs') do
  its(:content){ should match "PASS_MAX_DAYS\t99999"}
  its(:content){ should match "PASS_MIN_DAYS\t0"}
  its(:content){ should match "PASS_WARN_AGE\t7"}
end

RSpec.configure do |config|
  config.after(:suite) do
    replace_report_title
  end
end


