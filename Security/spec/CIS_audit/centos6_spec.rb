require 'spec_helper_ssh'

describe 'Add nodev Option to /dev/shm Partition' do
  describe file('/dev/shm') do
    it { should be_mounted.with( :options => { nodev: true }) }
    it { should be_mounted.with( :options => { nosuid: true }) }
    it { should be_mounted.with( :options => { noexec: true }) }
  end
end

describe "Disable Mounting of below Filesystems" do
  describe command('/sbin/lsmod') do
    its(:stdout) {should_not match /cramfs/}
    its(:stdout) {should_not match /freevxfs/}
    its(:stdout) {should_not match /jffs2/}
    its(:stdout) {should_not match /hfs/}
    its(:stdout) {should_not match /hfsplus/}
    its(:stdout) {should_not match /squashfs/}
    its(:stdout) {should_not match /udf/}
    its(:stdout) {should_not match /dccp/}
    its(:stdout) {should_not match /sctp/}
    its(:stdout) {should_not match /rds/}
    its(:stdout) {should_not match /tipc/}
  end
end

describe 'Verify that gpgcheck is Globally Activated' do
  describe file('/etc/yum.conf') do
    its(:content) {should match "gpgcheck=1"}
  end
end

describe 'Obtain Software Package Updates with yum' do
  describe command('yum check-update') do
    its(:exit_status) {should eq 0}
  end
end

describe 'Check for installed packages' do
  %w(aide ntp openldap-servers openldap-clients tcp_wrappers rsyslog cronie-anacron).each do |pkg|
    describe package(pkg) do
      it {should be_installed}
    end
  end
end

describe 'Implement Periodic Execution of File Integrity' do
  describe cron do
    it { should have_entry '* * * * * /usr/local/bin/foo' }
  end
end

describe 'Check for SELinux State' do
  describe file('/etc/grub.conf') do
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 400 }
    its(:content) {should_not match "selinux=0"}
    its(:content) {should_not match "enforcing=0"}
    its(:content) {should_not match /^password/}
  end

  describe file('/etc/selinux/config') do
    its(:content) {should_not match "SELINUX=enforcing"}
    its(:content) {should_not match "SELinux status:\s+enabled"}
    its(:content) {should_not match "Current mode:\s+enforcing"}
    its(:content) {should_not match "Mode from config file:\s+enforcing"}
    its(:content) {should_not match "SELINUXTYPE=targeted"}
  end
end

describe ' Check for SELinux Policy' do
  describe command('/usr/sbin/sestatus') do
    its(:stdout) {should match "Policy from config file: targeted"}
  end
end

describe 'Check for removed packages' do
  %w(setroubleshoot mcstrans telnet-server telnet rsh-server rsh ypbind ypserv tftp tftp-server talk talk-server xinetd xorg-x11-server-common dhcp bind vsftpd httpd dovecot samba squid net-snmp).each do |pkg|
    describe package(pkg) do
      it {should_not be_installed}
    end
  end
end

describe "Check for Unconfined Daemons" do
  describe command('ps -eZ | egrep "initrc" | egrep -vw "tr|ps|egrep|bash|awk" | tr ":" " " | awk \'{print $NF }\'') do
    its(:stdout) {should match ""}
  end
end

describe 'Check Authentication for Single-User Mode' do
  describe file('/etc/sysconfig/init') do
    its(:content) {should match /^SINGLE=\/sbin\/sulogin/}
    its(:content) {should match /^PROMPT=no/}
  end
end

describe 'Additional Process Hardening' do
  describe file('/etc/security/limits.conf')do
    its(:content) {should match /\*\s+hard\s+core\s+0/}
  end

  describe command('/sbin/sysctl fs.suid_dumpable') do
    its(:stdout) {should match /^fs\.suid_dumpable = 0/}
  end

  describe command('/sbin/sysctl kernel.exec-shield') do
    its(:stdout) {should match "kernel.exec-shield = 1"}
  end

  describe command('/sbin/sysctl kernel.randomize_va_space') do
    its(:stdout) {should match "kernel.randomize_va_space = 2"}
  end
end

describe 'check for package update' do
  describe command('yum check-update') do
    its(:stdout) {should_not match /^centos-release/}
    its(:stdout) {should_not match /^kernel\./}
  end
end

describe 'checking service status' do
  %w(chargen-dgram chargen-stream daytime-dgram daytime-stream echo-dgram tcpmux-server avahi-daemon cups nfslock rpcgssd rpcbind rpcidmapd rpcsvcgssd).each do |service|
    describe service(service) do
      it {should_not be_enabled}
      it {should_not be_running}
    end
    %w(iptables ip6tables auditd crond).each do |service|
      describe service(service) do
        it {should be_enabled}
        it {should be_running}
      end
    end
  end
end


describe 'check for umask in system-wide init config' do
  describe file('/etc/sysconfig/init') do
    its(:content) {should match "umask 027"}
  end
end

describe '/etc/inittab is set to runlevel 3' do
  describe file('/etc/inittab') do
    its(:content) {should match /id:3:initdefault:/}
  end
end

describe 'Configure Network Time Protocol (NTP)' do
  describe file('/etc/ntp.conf') do
    it {should be_file}
    its(:content) {should match 'restrict default'}
    its(:content) {should match 'restrict -6 default'}
    its(:content) {should match 'server'}
  end
end

describe 'check of configured to start ntpd as a nonprivileged user' do
  describe file('/etc/sysconfig/ntpd') do
    its(:content) {should match /OPTIONS=.*-u /}
  end
end

describe 'Configure Mail Transfer Agent for Local-Only Mode' do
  describe command('rpm -q postfix') do
    postfix_state = command('rpm -q postfix').stdout
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
end

describe 'Check for filre permissions' do
  %w(/etc/hosts.allow /etc/hosts.deny).each do |fname|
    describe file(fname) do
      it {should be_file}
      it { should be_mode 644 }
    end
  end
end

describe 'Configure /etc/rsyslog.conf' do
  describe file('/etc/rsyslog.conf') do
    its(:content) {should match "/var/log/messages"}
    its(:content) {should match "/var/log/kern.log"}
    its(:content) {should match "/var/log/daemon.log"}
    its(:content) {should match "/var/log/syslog"}
    its(:content) {should match /\*\.\* @/}
  end
end

describe 'Configure Audit Log Storage Size' do
  describe file('/etc/audit/auditd.conf') do
    its(:content) {should match /^max_log_file = \d+/}
    its(:content) {should match /^space_left_action = email/}
    its(:content) {should match /^action_mail_acct = root/}
    its(:content) {should match /^admin_space_left_action = halt/}
    its(:content) {should match /^max_log_file_action = keep_logs/}
  end
end

describe 'system logs have entries in /etc/logrotate.d/syslog' do
  describe file('/etc/logrotate.d/syslog') do
    its(:content) {should match /\/var\/log\/cron/}
    its(:content) {should match /\/var\/log\/boot.log/}
    its(:content) {should match /\/var\/log\/spooler/}
    its(:content) {should match /\/var\/log\/maillog/}
    its(:content) {should match /\/var\/log\/secure/}
    its(:content) {should match /\/var\/log\/messages/}
  end
end

describe 'Set User/Group Owner and Permission to file' do
  %w(/etc/anacrontab /etc/crontab /etc/ssh/sshd_config).each do |fname|
    describe file(fname) do
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should be_mode 600 }
    end
  end
  %w(/etc/cron.hourly /etc/cron.daily /etc/cron.weekly /etc/cron.monthly /etc/cron.d /etc/at.allow /etc/cron.allow).each do |fname|
    describe file(fname) do
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should be_mode 700 }
    end
  end
end

describe 'Check configure of SSH' do
  describe file('/etc/ssh/sshd_config') do
    it {should be_file}
    its(:content) {should_not match /^Protocol 1/}
    its(:content) {should_not match /^LogLevel (QUIET|FATAL|ERROR|VERBOSE|DEBUG.+)/}
    its(:content) {should_not match /^X11Forwarding\s+yes/}
    its(:content) {should_not match /^MaxAuthTries\s+[0-4]/}
    its(:content) {should_not match /^IgnoreRhosts\s+no/}
    its(:content) {should_not match /^HostbasedAuthentication\s+yes/}
    its(:content) {should match /^PermitRootLogin\s+no/}
    its(:content) {should_not match /^PermitEmptyPasswords\s+yes/}
    its(:content) {should_not match /^PermitUserEnvironment\s+yes/}
    its(:content) {should match /^Ciphers\s+aes128-ctr,aes192-ctr,aes256-ctr/}
    its(:content) {should match /^ClientAliveInterval\s+[1-9]+/}
    its(:content) {should match /^ClientAliveCountMax\s+0/}
    its(:content) {should match /^(AllowUsers|AllowGroups|DenyUsers|DenyGroups).+/}
    its(:content) {should match /^Banner.*\/etc\/issue.*/}
  end
end

describe 'Check configure of PAM' do
  describe file('/etc/pam.d/system-auth') do
    it {should be_file}
    its(:content) {should match /pam_pwquality.so/}
    its(:content) {should match /auth required pam_faillock.so preauth audit silent deny=5 unlock_time=900/}
    its(:content) {should match /auth \[default=die\] pam_faillock.so authfail audit deny=5 unlock_time=900/}
    its(:content) {should match /auth sufficient pam_faillock.so authsucc audit deny=5 unlock_time=900/}
    its(:content) {should match /auth \[success=1 default=bad\] pam_unix.so/}
    its(:content) {should match /auth \/password sufficient pam_unix.so remember=5/}
  end
  describe file('/etc/pam.d/password-auth') do
    it {should be_file}
    its(:content) {should match /auth required pam_faillock.so preauth audit silent deny=5 unlock_time=900/}
    its(:content) {should match /auth \[default=die\] pam_faillock.so authfail audit deny=5 unlock_time=900/}
    its(:content) {should match /auth sufficient pam_faillock.so authsucc audit deny=5 unlock_time=900/}
    its(:content) {should match /auth \[success=1 default=bad\] pam_unix.so/}
  end
  describe command('/sbin/authconfig --test') do
    its(:stdout) {should match /hashing.*sha512/}
  end
  describe file('/etc/security/pwquality.conf') do
    it {should be_file}
    its(:content) {should match /minlen=14/}
    its(:content) {should match /dcredit=-1/}
    its(:content) {should match /ucredit=-1/}
    its(:content) {should match /ocredit=-1/}
    its(:content) {should match /lcredit=-1/}
  end
  describe file('/etc/pam.d/su') do
    it {should be_file}
    its(:content) {should match /auth required pam_wheel.so use_uid/}
  end
  describe file('/etc/group') do
    it {should be_file}
    its(:content) {should match /auth required pam_wheel.so use_uid/}
  end
end

describe 'User Accounts and Environment' do
  describe file('/etc/login.defs') do
    it {should be_file}
    its(:content) {should match /^PASS_MAX_DAYS\s+[1-9]{2}/}
    its(:content) {should match /^PASS_MIN_DAYS\s+[1-7]/}
    its(:content) {should match /^PASS_WARN_AGE\s+([7-9]|[1-9]\d+)/}
  end
end

describe 'Default Group for root Account' do
  describe group('root') do
    it { should exist }
    it { should have_uid 0 }
  end

  describe user('root') do
    it { should belong_to_group 'root' }
  end
end

describe 'Default umask for Users' do
  describe file('/etc/bashrc') do
    it {should be_file}
    its(:content) {should match /umask 077/}
  end
end

describe 'Lock Inactive User Accounts' do
  describe file('/etc/default/useradd') do
    it {should be_file}
    its(:content) {should match /^INACTIVE=35/}
  end
end

describe 'Warning Banner for Standard Login Services' do
  %w(/etc/motd /etc/issue /etc/issue.net /etc/passwd).each do |fname|
    describe file(fname) do
      it {should be_file}
      it { should be_mode 644 }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
    end
  end
end

describe 'GNOME Warning Banner' do
  describe command('gconftool-2 --get /apps/gdm/simple-greeter/banner_message_text') do
    its(:stdout) {should match "No value set for.*"}
  end
end

describe 'Verify System File Permissions' do
  describe command('rpm -Va --nomtime --nosize --nomd5 --nolinkto') do
    its(:stdout) {should match ""}
  end
end

describe 'Ensure Password Fields are Not Empty' do
  describe command('/bin/awk -F: \'($2 == "" ) { print $1 }\' /etc/shadow') do
    its(:stdout) {should match ""}
  end
end

describe 'Verify No UID 0 Accounts Exist Other Than root' do
  describe command('/bin/awk -F: \'($3 == 0) { print $1 }\' /etc/passwd') do
    its(:stdout) {should match /^root$/}
  end
end


