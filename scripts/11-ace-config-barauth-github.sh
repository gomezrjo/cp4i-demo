#!/bin/sh
echo "Building BAR Auth Configuration"
###################
# INPUT VARIABLES #
###################
CONFIG_NAME="github-barauth"
CONFIG_TYPE="barauth"
CONFIG_NS="tools"
CONFIG_DESCRIPTION="Authentication for GitHub"
CONFIG_DATA_BASE64=$(base64 -i templates/template-ace-barauth-data.json)
########################
# CREATE CONFIGURATION #
########################
( echo "cat <<EOF" ; cat templates/template-ace-config-data.yaml ;) | \
    CONFIG_NAME=${CONFIG_NAME} \
    CONFIG_TYPE=${CONFIG_TYPE} \
    CONFIG_NS=${CONFIG_NS} \
    CONFIG_DESCRIPTION=${CONFIG_DESCRIPTION} \
    CONFIG_DATA_BASE64=${CONFIG_DATA_BASE64} \
    sh > ace-config-barauth.yaml
echo "Creating ACE Configuration..."
oc apply -f ace-config-barauth.yaml
oc -n tools label configuration github-barauth assembly.integration.ibm.com/tools.jgr-demo=true
echo "Cleaning up temp files..."
rm -f ace-config-barauth.yaml
echo "BAR Auth Configuration has been created."