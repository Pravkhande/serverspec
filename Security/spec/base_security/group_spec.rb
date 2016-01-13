require 'spec_helper_ssh'


describe group('root') do
  it { should exist }
end

