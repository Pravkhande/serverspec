require 'spec_helper_ssh'
require "rspec/expectations"
require 'utilities'

describe user('root') do
  it { should exist }
  it { should belong_to_group 'root' }
  it { should have_uid 0 }
  it { should have_home_directory '/root' }
  it { should have_login_shell '/bin/bash' }
end

RSpec.configure do |config|
  config.after(:suite) do
    replace_report_title
  end
end
