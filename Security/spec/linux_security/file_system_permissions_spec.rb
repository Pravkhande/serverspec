require 'spec_helper_ssh'

# This block check mode of home
describe file("/home") do
  it { should be_mode 755 }
end




