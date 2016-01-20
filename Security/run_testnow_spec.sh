export SPEC_HOST_AUTHENTICATION="$SPEC_AUTHENTICATION"
export SPEC_HOST_NAME="$SPEC_IP"
export SPEC_USER="$SPEC_USER"
export SPEC_PASSWORD="$SPEC_PASSWORD"
export HOST_ROLE="$ROLE"

#rake spec:"$HOST_ROLE" TITLE="${TITLE}"
rake security:"$HOST_ROLE" TITLE="${TITLE}"
echo "-------------"
echo ${TITLE}
echo "-------------"

destOutPut="/var/www/html/${JOB_ID}/${RUN_ID}"

#scp  -o StrictHostKeyChecking=no -r -i $WORKING_DIR/TestNow.key ${WORKING_DIR}/code/Security/reports/${SPEC_HOST_NAME}* ubuntu@$WEB_SERVER_IP:$destOutPut

#ruby $WORKING_DIR/InfraTestDataParser.rb ${SPEC_HOST_NAME} ${HOST_ROLE}

ruby $WORKING_DIR/InfraTestDataParser.rb ${SPEC_HOST_NAME} ${HOST_ROLE}

echo "********************************************************************************************"
echo "* Report for this execution has been created in Reports folder as 'serverspec_report.html' *"
echo "********************************************************************************************"

