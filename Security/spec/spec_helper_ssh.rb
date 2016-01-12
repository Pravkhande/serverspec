
# This block is for ssh machine using password
require 'serverspec'
require 'net/ssh'

set :backend, :ssh

if ENV['ASK_SUDO_PASSWORD']
  begin
    require 'highline/import'
  rescue LoadError
    fail "highline is not available. Try installing it."
  end
  set :sudo_password, ask("Enter sudo password: ") { |q| q.echo = false }
else
  set :sudo_password, ENV['SPEC_PASSWORD']
end



options = Net::SSH::Config.for(host)
options[:user] = ENV['SPEC_USER']
options[:host_name] = ENV['SPEC_HOST_NAME']
options[:password] = ENV['SPEC_PASSWORD']

set :host,        options[:host_name] || host
set :ssh_options, options





