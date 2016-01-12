export SPEC_HOST_NAME="$SPEC_IP"
export SPEC_USER="$SPEC_USER"
export SPEC_PASSWORD="$SPEC_PASSWORD"



rake spec:linux_security


echo "********************************************************************************************"
echo "* Report for this execution has been created in Reports folder as 'serverspec_report.html' *"
echo "********************************************************************************************"

