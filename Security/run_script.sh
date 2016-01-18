#!/bin/sh

#This block is used for machine details from file

#IFS=$'\n' GLOBIGNORE='*' command eval  'IPs=($(cat data/parameters.txt))'
#
#
#for i in "${IPs[@]}"
#do
#        str=$i
#        IFS=':' read -ra ary <<< "$str"
#
#        echo ${ary[0]}
#        echo ${ary[1]}
#        echo ${ary[2]}
#        echo ${ary[3]}
#        export SPEC_AUTHENTICATION=${ary[0]}
#        export SPEC_IP=${ary[1]}
#        export SPEC_USER=${ary[2]}
#        export SPEC_PASSWORD=${ary[3]}
#        nohup bash run_testnow_spec.sh  >> out.txt 2>&1 &
#
#done

#This block is used for machine details from environment variable
bundle install
IFS=$';' GLOBIGNORE='*' command eval  'IPs=($IPS)'
for i in "${IPs[@]}"
do
        echo $i
        str=$i
        IFS=':' read -ra ary <<< "$str"

        echo ${ary[0]}
        echo ${ary[1]}
        echo ${ary[2]}
        echo ${ary[3]}
        export SPEC_AUTHENTICATION=${ary[0]}
        export SPEC_IP=${ary[1]}
        export SPEC_USER=${ary[2]}
        export SPEC_PASSWORD=${ary[3]}
        if [ "${SPEC_AUTHENTICATION}" = "key" ]
        then
        touch "key/${SPEC_USER}_${SPEC_IP}.key"
        echo -e "${SPEC_PASSWORD}" > "key/${SPEC_USER}_${SPEC_IP}.key"
        chmod 600 key/${SPEC_USER}_${SPEC_IP}.key
        fi

       nohup bash run_testnow_spec.sh  >> out.txt 2>&1 &

done







