require 'spec_helper_ssh'

describe file("/etc/gshadow") do
  it { should be_owned_by 'root' }
end

describe file("/etc/passwd") do
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should be_mode 644 }
end

describe file("/etc/group") do
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should be_mode 644 }
end

%w(/etc/rpmrc /root/.rpmrc /etc/hosts.equiv).each do |fname|
  describe file(fname) do
    it { should_not exist }
  end
end

%w(/lib /lib64 /usr/lib /usr/lib64).each do |fname|
  describe file(fname) do
    it { should be_owned_by 'root' }
  end
end

%w(/bin /usr/bin /usr/local/bin /sbin /usr/sbin /usr/local/sbin).each do |fname|
  describe file(fname) do
    it { should be_owned_by 'root' }
  end
end

describe file("/etc/login.defs") do
  its(:content) { should match "ENCRYPT_METHOD SHA512"}
end

describe file("/etc/ssh/sshd_config") do
  its(:content) {should match "PrintLastLog yes"}
end

describe command("find /home -maxdepth 2 -name '.hushlogin'") do
  its(:stdout) { should match ""}
end

describe package('logrotate') do
  it {should be_installed}
end


describe command("find /home -maxdepth 2 -name '.rhosts'") do
  its(:stdout) { should match ""}
end

describe command('egrep -v "^\+" /etc/passwd | awk -F: \'($1!="root" && $3<500 && $2!="x") {print}\'') do
  its(:stdout) { should match ""}
end

describe command('awk -F: \'($2 != "x") {print}\' /etc/passwd') do
  its(:stdout) { should match ""}
end

%w(net.ipv4.ip_forward net.ipv4.conf.all.accept_source_route net.ipv4.conf.all.log_martians net.ipv4.conf.all.log_martians).each do |param|
  describe 'Linux kernel parameters' do
    context linux_kernel_parameter(param) do
      its(:value) { should eq 0 }
    end
  end
end

%w(net.ipv4.conf.all.accept_redirects net.ipv4.conf.all.secure_redirects net.ipv4.conf.default.accept_source_route net.ipv4.icmp_echo_ignore_broadcasts net.ipv4.icmp_ignore_bogus_error_responses net.ipv4.tcp_syncookies net.ipv4.conf.all.rp_filter net.ipv4.conf.default.rp_filter net.ipv6.conf.default.accept_redirects net.ipv4.conf.all.send_redirects).each do |param|
  describe 'Linux kernel parameters' do
    context linux_kernel_parameter(param) do
      its(:value) { should eq 1 }
    end
  end
end

%w(xinetd telnet rexec rsh rlogin ypbind tftp abrtd ntpdate oddjobd qpidd rdisc netconsole).each do |service|
  describe service(service) do
    it { should_not be_enabled }
    it { should_not be_running }
  end
end

%w(xinetd telnet-server rsh-server ypserv tftp-server openldap-servers).each do |pkg|
  describe package(pkg) do
    it {should_not be_installed}
  end
end

describe file('/etc/issue') do
  it {should exist}
  it {should be_file}
end

describe command('find /home -maxdepth 2 -xdev -name .netrc') do
  its(:stdout) {should match ""}
end

describe file('/etc/ssh/sshd_config') do
  its(:content) {should match "Protocol 2"}
  its(:content) {should match "IgnoreRhosts"}
  its(:content) {should match "HostbasedAuthentication no"}
  its(:content) {should match "PermitEmptyPasswords no"}
end

describe file('/etc/cron.daily/logrotate') do
  it {should exist}
  it {should be_file}
end