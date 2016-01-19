require 'spec_helper_ssh'
require "rspec/expectations"
require 'utilities'

describe file('/run/shm') do
  it { should be_mounted.with( :options => { nodev: true } ) }
  it { should be_mounted.with( :options => { nosuid: true } ) }
  it { should be_mounted.with( :options => { noexec: true } ) }
end

describe command('/sbin/lsmod') do
  its(:stdout) {should_not match "cramfs"}
  its(:stdout) {should_not match "freevxfs"}
  its(:stdout) {should_not match "jffs2"}
  its(:stdout) {should_not match "hfs"}
  its(:stdout) {should_not match "hfsplus"}
  its(:stdout) {should_not match "squashfs"}
  its(:stdout) {should_not match "udf"}
end

describe file('/boot/grub/grub.cfg') do
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should be_mode 600 }
end

describe file('/etc/shadow') do
  its(:content) {should_not match /^root:[*\!]:/}
end

describe file('/etc/security/limits.conf') do
  its(:content) {should match /\*\s+hard\s+core\s+0/}
end

describe command('/sbin/sysctl fs.suid_dumpable') do
  its(:stdout) {should match "fs.suid_dumpable = 2"}
end

%w(apport xinetd openbsd-inetd isc-dhcp-serve isc-dhcp-server6 rpcbind rpcbind-boot nfs-kernel-server bind9 vsftpd dovecot squid3 snmpd).each do |service|
describe service(service) do
  it { should_not be_enabled }
  it { should_not be_running }
end
end

%w(prelink nis rsh-server rsh-redone-server rsh-client rsh-redone-client talk xinetd openbsd-inetd xserver-common slapd biosdevname).each do |pkg|
describe package(pkg) do
  it {should_not be_installed}
end
end

%w(ufw rsyslog cron).each do |service|
describe service(service) do
  it { should be_enabled }
  it { should be_running }
end
end

describe command('/usr/sbin/apparmor_status') do
  its(:stdout) { should match "apparmor module is loaded."}
end

%w(tcpd rsyslog).each do|pkg|
describe package(pkg) do
  it {should be_installed}
end
end

%w(21 110 995 143 993 3128 161 162 873 514).each do |port|
describe port(port) do
  it { should_not be_listening }
end
end

describe command('dpkg -l postfix') do
  postfix_state = command('dpkg -l postfix').stdout
  if postfix_state =~ /^ii\s+postfix/
    describe port(25) do
      it { should be_listening.with('127.0.0.1') }
    end
  else
    describe port(25) do
      it { should_not be_listening }
    end
    end
  end

describe file('/etc/default/rsync') do
  its(:content) {should_not match "RSYNC_ENABLE=false'"}
end

describe command('ip addr') do
  its(:stdout) {should match "inet6"}
end

%w(/etc/hosts.allow /etc/hosts.deny).each do |fname|
describe file(fname) do
  it {should exist}
  it {should be_file}
  it { should be_mode 644 }
end
end

describe file('/etc/rsyslog.d/50-default.conf') do
  its(:content) {should match "/var/log/auth.log"}
  its(:content) {should match "/var/log/cron.log"}
  its(:content) {should match "/var/log/daemon.log"}
  its(:content) {should match "/var/log/kern.log"}
  its(:content) {should match "/var/log/lpr.log"}
  its(:content) {should match "/var/log/mail.err"}
  its(:content) {should match "/var/log/mail.info"}
  its(:content) {should match "/var/log/mail.log"}
  its(:content) {should match "/var/log/mail.warn"}
  its(:content) {should match "/var/log/syslog"}
  its(:content) {should match "/var/log/user.log"}
end

describe file('/etc/logrotate.d/rsyslog') do
  its(:content) {should match /\/var\/log\/auth.log/}
  its(:content) {should match /\/var\/log\/cron.log/}
  its(:content) {should match /\/var\/log\/daemon.log/}
  its(:content) {should match /\/var\/log\/debug/}
  its(:content) {should match /\/var\/log\/kern.log/}
  its(:content) {should match /\/var\/log\/lpr.log/}
  its(:content) {should match /\/var\/log\/mail.err/}
  its(:content) {should match /\/var\/log\/mail.info/}
  its(:content) {should match /\/var\/log\/mail.log/}
  its(:content) {should match /\/var\/log\/mail.warn/}
  its(:content) {should match /\/var\/log\/messages/}
  its(:content) {should match /\/var\/log\/syslog/}
  its(:content) {should match /\/var\/log\/user.log/}
end

describe file('/etc/crontab') do
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should be_mode 600 }
end

%w(/etc/crontab /etc/cron.weekly /etc/cron.monthly).each do |fname|
describe file(fname) do
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should be_mode 700 }
end
end

describe command('useradd -D') do
  its(:stdout) {should match /INACTIVE=(\d*)/}
end

%w(/etc/issue /etc/issue.net /etc/passwd /etc/group).each do |fname|
  describe file(fname) do
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 644 }
  end
end

describe file('/etc/shadow') do
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'shadow' }
  it { should be_mode 640 }
end

describe command('/usr/bin/awk -F: \'($2 == "" ) { print $1 }\' /etc/shadow') do
  its(:stdout) {should match ""}
end

describe command('/usr/bin/awk -F: \'($3 == 0) { print $1 }\' /etc/passwd') do
  its(:stdout) {should match "root"}
end

RSpec.configure do |config|
  config.after(:suite) do
    replace_report_title
  end
end
