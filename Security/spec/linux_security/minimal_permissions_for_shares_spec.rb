require 'spec_helper_ssh'

# This block check for service status
%w(nfsserver smb nmb).each do |sname|
  describe service(sname) do
    it { should_not be_enabled }
  end
end


