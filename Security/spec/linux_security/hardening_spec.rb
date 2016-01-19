require 'spec_helper_ssh'
require "rspec/expectations"
require 'utilities'


# This block check for file content path should not match .,..,;
%w(/etc/bash.bashrc /etc/profile).each do |fname|
  describe file(fname) do
    out = command("cat #{fname}").stdout
    out.each_line do |line|
      if (line.match(/PATH=(\S*)/))
        path = line.match(/PATH=(\S*)/)
        target_path = line.split("=").last
        puts target_path

        if (target_path.match(/\./))
          describe target_path do
            it "should contain ." do
            end
          end
        else
          describe target_path do
            it "should not contain ." do
            end
          end
        end
        if (target_path.match(/\.\./))
          describe target_path do
            it "should contain .." do
            end
          end
        else
          describe target_path do
            it "should not contain .." do
            end
          end
        end

        if (target_path.match(/;/))
          describe target_path do
            it "should contain ;" do
            end
          end
        else
          describe target_path do
            it "should not contain ;" do
            end
          end
        end
      end

    end
  end
end


# This block check for command output
describe command("ls -al /etc/fstab") do
  cmd = command("ls -al /etc/fstab").stdout
  cmd1 = cmd.split(" ").first
  its(:stdout) {should match cmd1}
end

# This block take 2nd column from command and check if it matches with required value
describe command("df -h -T |awk '{print $2}'") do
  out = command("df -h -T |awk '{print $2}'").stdout
  out1 = out.split("\n")
  out1.each do |val|
    if (val.include?("ext2")) || (val.include?("ext3")) || (val.include?("ext4")) || (val.include?("reiserFS"))
      describe command("df -h -T") do
        its(:stdout){should match val}
      end
    end
  end
end



# This block take each file and check for command exist status
describe command("find /bin/umount -perm -4000 -o -perm -2000 -print") do
  its(:exit_status) {should eq 0}
end


describe command("find /bin/mount -perm -4000 -o -perm -2000 -print") do
  its(:exit_status) {should eq 0}
end



# This block check for service status
describe service("boot.kdump") do
  it { should_not be_enabled }
end

# This block check mode of root
describe file("/root") do
  it { should be_mode 700 }
end


# This block check for package installation
%w(llvm- clang- gcc- open64- pcc-).each do |pkg|
  describe command("rpm -qa | grep #{pkg}") do
    pkg_list = command("rpm -qa | grep #{pkg}").stdout
    describe package(pkg_list) do
      it {should_not be_installed}
    end
  end
end


# This block take directory from command output and check directory mode
describe command('ls -d /etc/cron*') do
  result1 = command('ls -d /etc/cron*').stdout
  result = result1.split(" ")
  result.each do |dir|
    puts dir
    describe command("find #{dir} -perm 640") do
      its(:stdout) {should match ""}
    end
  end
end

# This block take directory from command output and check directory mode
describe command('ls -d /var/spool/cron/*') do
  result1 = command('ls -d /var/spool/cron/*').stdout
  result = result1.split(" ")
  result.each do |dir|
    puts dir
    describe command("find #{dir} -perm 600") do
      its(:stdout) {should match ""}
    end
  end
end


# This block check for command output
describe command("/sbin/sysctl -a | grep randomize_va") do
  its(:stdout) {should match "kernel.randomize_va_space = 2"}
end


# This block check for system version and check the command
describe command("/sbin/sysctl -w fs.protected_hardlinks=1") do
  its(:stdout) { should match "fs.protected_hardlinks=1\n" }
end

describe command("/sbin/sysctl -w fs.protected_symlinks=1") do
  its(:stdout) { should match "fs.protected_symlinks=1\n" }
end


RSpec.configure do |config|
  config.after(:suite) do
    replace_report_title
  end
end

