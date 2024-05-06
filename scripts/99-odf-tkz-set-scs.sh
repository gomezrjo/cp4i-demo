#!/bin/sh
# This script requires the oc command being installed in your environment 
if [ ! command -v oc &> /dev/null ]; then echo "oc could not be found"; exit 1; fi;
if [ -z "$OCP_TYPE" ]; then echo "OCP_TYPE not set, it must be provided on the command line."; exit 1; fi;
echo "OCP_TYPE is set to" $OCP_TYPE
if [ "$OCP_TYPE" != "ODF" ]; then echo "This script is for OCP with ODF SCs"; exit 1; fi;
read -p "Press <Enter> to execute script..."
if [ $(oc get sc | grep default | wc -l) -gt 0 ]
then
    oc get sc | grep default | awk '{system("oc patch storageclass " $1 " --patch-file resources/99-sc-remove-default.yaml")}'
fi
oc patch storageclass ocs-storagecluster-ceph-rbd --patch-file resources/99-sc-set-default.yaml
