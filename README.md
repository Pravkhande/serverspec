# TEST-AUTOMATION(ServerSpecS)
ServerSpecS for Infrastructure level security tests to be used by TestNow

## OVERVIEW:

These are serverspecs for TestNow.

These serverspecs act as Quality Assurance on OS level and Infrastructure level for the VM's that are created by the Chef recipes. Each spec is executed on the VM checking a specific functionality. These serverspec connect to the remote VM's using ssh to the hostname@IP with either password or a key.


## REQUIREMENTS:
* __Ruby__
* __Gem : Bundler__
* __Gem : Rake__

## SETUP
1. __git clone https://gitlab.com/opexsw/infra-tests.git__
2. __cd Security
3. __sudo bundle install (this will install all dependencies for running serverspecs)__

## PRE-SCRIPT
Before we can execute serverspecs, we need to set some environment variables which will be read by the serverspecs
Here is the list of environment variables we need to set:

1. __IPS__ : Type of authentication required (password/key)
	* Password : Authetication using HOST_USER's password(export IPS="password:<HOST_IP>:<HOST_USERNAME>:<HOST_PASSWORD>")
    * Key : Authetication using key(export IPS="key:<HOST_IP>:<HOST_USERNAME>:<KEY_CONTENT>")
2. __ROLE__ : Role is mainly name of spec which spec you want to run.(export ROLE="security_role")



## TYPES OF EXECUTION

1. __CIS_audit__ :This specs check for the CIS Benchmarks. Each spec check for entire benchmark's. It included mainly for centos6, centos7 and ubuntu OS specs.

2. __base_security__ :This spec checking basic security requirement for all OS. It included mainly file,group,host,port,user related specs.

3. __linux_security__ : This will execute all the specs related to accounts,file permissions,hardening,password security and services. Here mainly the specs will ensure the quality and security of the __OS__ being installed on the VM and check if all the setting and permissions are done as per the requirements.

4. __security_audit__ :This spec automating a security audit of EL based Linux systems.

## EXECUTION
* __bash run_script.sh (this will execute all specs included in linux_security)__


