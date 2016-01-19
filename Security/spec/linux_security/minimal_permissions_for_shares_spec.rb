require 'spec_helper_ssh'
require "rspec/expectations"
require 'utilities'


# This block check for service status
%w(nfsserver smb nmb).each do |sname|
  describe service(sname) do
    it { should_not be_enabled }
  end
end

RSpec.configure do |config|
  config.after(:suite) do
    replace_report_title
  end
end

