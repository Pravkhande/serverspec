require 'spec_helper_ssh'
require "rspec/expectations"
require 'utilities'

describe host('127.0.0.1') do
  it { should be_reachable }
end

describe host('127.0.0.1') do
  it { should be_reachable.with(:proto => 'icmp', :timeout=> 1) }
end

describe host('127.0.0.1') do
  it { should be_reachable.with(:proto => 'tcp', :port => 22, :timeout=> 1) }
end

describe host('www.google.com') do
  it { should     be_resolvable             }
  it { should     be_resolvable.by('dns')   }
  it { should_not be_resolvable.by('hosts') }
end

RSpec.configure do |config|
  config.after(:suite) do
    replace_report_title
  end
end
