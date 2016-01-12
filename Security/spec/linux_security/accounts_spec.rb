require 'spec_helper_ssh'

# This block check user in the file
describe file('/etc/passwd') do
  it { should exist }
  it { should be_file}
  its(:content){ should match "root"}
end

# This block check for user uid
describe user('root') do
  it { should have_uid 0 }
end

# This block check for user with uid 0 in file
describe command("awk -F: '($3 == '0') {print}' /etc/passwd") do
  its(:stdout){ should match "root" }
end