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

## TYPES OF EXECUTION

* __linux_security__ : This will execute all the specs related to accounts,file permissions,hardening,password security and services. Here mainly the specs will ensure the quality and security of the __OS__ being installed on the VM and check if all the setting and permissions are done as per the requirements.

## EXECUTION
* __bash run_script.sh (this will execute all specs included in linux_security)__


