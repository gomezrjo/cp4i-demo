#!/bin/sh
echo "Building MQ Policy Configuration"
###################
# INPUT VARIABLES #
###################
CONFIG_NAME="ace-qmgr-demo-policy"
CONFIG_TYPE="policyproject"
CONFIG_NS="tools"
CONFIG_DESCRIPTION="Policy to connect to Demo Queue Manager"
##########################
# PREPARE CONFIG CONTENT #
##########################
echo "Packaging Policy..."
mkdir CP4iQMGRDEMO && cp -a ../cp4i-ace-artifacts/CP4iQMGRDEMO/. CP4iQMGRDEMO/
zip -r CP4iQMGRDEMO.zip CP4iQMGRDEMO
CONFIG_CONTENT_BASE64=$(base64 -i CP4iQMGRDEMO.zip)
( echo "cat <<EOF" ; cat templates/template-ace-config-content.yaml ;) | \
CONFIG_NAME=${CONFIG_NAME} \
CONFIG_TYPE=${CONFIG_TYPE} \
CONFIG_NS=${CONFIG_NS} \
CONFIG_DESCRIPTION=${CONFIG_DESCRIPTION} \
CONFIG_CONTENT_BASE64=${CONFIG_CONTENT_BASE64} \
sh > ace-config-policy-mq.yaml
########################
# CREATE CONFIGURATION #
########################
echo "Creating ACE Configuration..."
oc apply -f ace-config-policy-mq.yaml
oc -n tools label configuration ace-qmgr-demo-policy assembly.integration.ibm.com/tools.jgr-demo=true
echo "Cleaning up temp files..."
rm -rf CP4iQMGRDEMO
rm -f CP4iQMGRDEMO.zip
rm -f ace-config-policy-mq.yaml
echo "MQ Policy Configuration has been created."