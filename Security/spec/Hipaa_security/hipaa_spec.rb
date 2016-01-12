require 'spec_helper_local'

describe file("/etc/gshadow") do
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should be_mode 000 }
end

# describe mail_alias('root') do
#   it { should be_aliased_to 'root' }
# end

describe file("/etc/shadow") do
  it { should be_mode 000 }
end

describe file("/etc/passwd") do
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should be_mode 644 }
end

describe command('grep "[[:space:]]/tmp[[:space:]]" /etc/fstab') do
  its(:stdout) { should_not match "" }
end


describe command('grep "[[:space:]]/var[[:space:]]" /etc/fstab') do
  its(:stdout) { should_not match "" }
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
  it { should be_mode 555 }
  it { should be_owned_by 'root' }
end
end

%w(/bin /usr/bin /usr/local/bin /sbin /usr/sbin /usr/local/sbin).each do |fname|
  describe file(fname) do
    it { should be_mode 555 }
    it { should be_owned_by 'root' }
  end
end

describe command("gconftool-2 --direct --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory --get/apps/gnome_settings_daemon/keybindings/screensaver") do
  its(:stdout) { should_not match "" }
end

describe file("/etc/login.defs") do
  its(:stdout) { should match "PASS_MIN_DAYS\t1"}
end

describe file("/etc/ssh/sshd_config") do
  its(:stdout) {should match "PrintLastLog\tyes"}
end

describe command("find /home -maxdepth 2 -name '.hushlogin'") do
  its(:stdout) { should match ""}
end

%w(ossec-hids aide).each do |pkg|
describe package(pkg) do
  it {should be_installed}
end
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

describe 'Linux kernel parameters' do
  context linux_kernel_parameter('net.ipv4.ip_forward') do
    its(:value) { should eq 1 }
    its(:value) { should eq 0 }
  end
end

%w(iptables ip6tables).each do |ser_name|
describe service(ser_name) do
  it { should be_enabled }
  it { should be_running }
end
end

describe 'Linux kernel parameters' do
  context linux_kernel_parameter('net.ipv4.conf.all.accept_source_route') do
    its(:value) { should eq 0 }
  end
end

describe 'Linux kernel parameters' do
  context linux_kernel_parameter('net.ipv4.conf.all.accept_redirects') do
    its(:value) { should eq 0 }
  end
end

describe 'Linux kernel parameters' do
  context linux_kernel_parameter('net.ipv4.conf.all.secure_redirects') do
    its(:value) { should eq 0 }
  end
end

describe 'Linux kernel parameters' do
  context linux_kernel_parameter('net.ipv4.conf.all.log_martians') do
    its(:value) { should eq 0 }
  end
end

describe 'Linux kernel parameters' do
  context linux_kernel_parameter('net.ipv4.conf.all.log_martians') do
    its(:value) { should eq 0 }
  end
end



