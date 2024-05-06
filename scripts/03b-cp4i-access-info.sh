#!/bin/sh
# This script requires the oc command being installed in your environment
if [ ! command -v oc &> /dev/null ]; then echo "oc could not be found"; exit 1; fi;
if [ -z "$CP4I_VER" ]; then echo "CP4I_VER not set, it must be provided on the command line."; exit 1; fi;
echo "CP4I_VER is set to" $CP4I_VER
read -p "Press <Enter> to execute script..."
CP4I_URL=$(oc get platformnavigator cp4i-navigator -n tools -o jsonpath='{range .status.endpoints[?(@.name=="navigator")]}{.uri}{end}')
if [ "$CP4I_VER" = "2023.4" ]
then 
    CP4I_USER=$(oc get secret integration-admin-initial-temporary-credentials -n ibm-common-services -o jsonpath={.data.username} | base64 -d)
    CP4I_PWD=$(oc get secret integration-admin-initial-temporary-credentials -n ibm-common-services -o jsonpath={.data.password} | base64 -d)
else
    CP4I_USER=$(oc get secret ibm-iam-bindinfo-platform-auth-idp-credentials -n tools -o jsonpath={.data.admin_username} | base64 -d)
    CP4I_PWD=$(oc get secret ibm-iam-bindinfo-platform-auth-idp-credentials -n tools -o jsonpath={.data.admin_password} | base64 -d)
fi
echo "CP4I Platform UI URL: " $CP4I_URL
echo "CP4I admin user: " $CP4I_USER
echo "CP4I admin password: " $CP4I_PWD