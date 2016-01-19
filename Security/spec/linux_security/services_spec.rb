require 'spec_helper_ssh'
require "rspec/expectations"
require 'utilities'


# This block check for services status
%w(anacron atd autofs avahi-daemon bluetooth cups GPM hidd hplip netfs nfs nfslock pcscd Portmap rpcbind rpcgssd rpcidmapd xfs).each do |off_services|
  describe service(off_services) do
    it { should_not be_enabled }
  end
end

%w(auditd cron haldaemon iptables kudzu ntpd sendmail syslog).each do |on_services|
  describe service(on_services) do
    it { should be_enabled }
  end
end


RSpec.configure do |config|
  config.after(:suite) do
    replace_report_title
  end
end

