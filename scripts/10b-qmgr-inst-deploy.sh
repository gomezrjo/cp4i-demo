#!/bin/sh
# This script requires the oc command being installed in your environment
# Before running the script you need to set two environment variables called "MAILTRAP_USER" and "MAILTRAP_PWD" with your maintrap info, using these command: 
# "export MAILTRAP_USER=my-mailtrap-user"
# "export MAILTRAP_PWD=my-mailtrap-pwd"
if [ ! command -v oc &> /dev/null ]; then echo "oc could not be found"; exit 1; fi;
if [ -z "$CP4I_VER" ]; then echo "CP4I_VER not set, it must be provided on the command line."; exit 1; fi;
if [ -z "$OCP_TYPE" ]; then echo "OCP_TYPE not set, it must be provided on the command line."; exit 1; fi;
if [ -z "$MAILTRAP_USER" ]; then echo "MAILTRAP_USER not set, it must be provided on the command line."; exit 1; fi;
if [ -z "$MAILTRAP_PWD" ]; then echo "MAILTRAP_PWD not set, it must be provided on the command line."; exit 1; fi;
echo "CP4I_VER is set to" $CP4I_VER
echo "OCP_TYPE is set to" $OCP_TYPE
if [ -z "$CP4I_TRACING" ]; then echo "CP4I Tracing is NOT enabled"; else echo "CP4I Tracing is enabled"; fi;
echo "MAILTRAP_USER is set to" $MAILTRAP_USER
echo "MAILTRAP_PWD is set to" $MAILTRAP_PWD
read -p "Press <Enter> to execute script..."
if [ -z "$CP4I_TRACING" ]
then
    echo "Deploying Queue Manager instance without tracing..."
    oc apply -f instances/${CP4I_VER}/${OCP_TYPE}/09-qmgr-ace-single-instance.yaml
else
    echo "Deploying Queue Manager instance with tracing enabled..."
    oc apply -f instances/${CP4I_VER}/${OCP_TYPE}/tracing/09-qmgr-ace-single-tracing-instance.yaml
fi
i=0
echo "Waiting for the Queue Manager instance to get ready..."
while [ $(oc get queuemanager --no-headers -n tools | awk '{print $2}') != "Running" ] && [ $i -lt 15 ]
do
    echo "Checking status..." $i
    echo "Sleeping for one minute..."
    sleep 60
    let "i++"
done
if [ $(oc get queuemanager --no-headers -n tools | awk '{print $2}') != "Running" ]
then
    echo "Something is wrong!"
    curl --ssl-reqd \
         --url "smtp://smtp.mailtrap.io:2525" \
         --user "${MAILTRAP_USER}:${MAILTRAP_PWD}" \
         --mail-from cp4i-admin@ibm.com \
         --mail-rcpt cp4i-user@ibm.com \
         --upload-file email-files/10b-qmgr-inst-deploy-failure.txt
else
    echo "Queue Manager is Ready."
    curl --ssl-reqd \
         --url "smtp://smtp.mailtrap.io:2525" \
         --user "${MAILTRAP_USER}:${MAILTRAP_PWD}" \
         --mail-from cp4i-admin@ibm.com \
         --mail-rcpt cp4i-user@ibm.com \
         --upload-file email-files/10b-qmgr-inst-deploy-success.txt
fi
echo "Done!"