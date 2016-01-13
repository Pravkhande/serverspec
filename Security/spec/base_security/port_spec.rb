require 'spec_helper_ssh'

describe port(53) do
  it { should be_listening.with('udp') }
end

