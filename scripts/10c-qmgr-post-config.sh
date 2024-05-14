#!/bin/sh
echo "Building CCDT to connect to Queue Manager"
###################
# INPUT VARIABLES #
###################
QMGR_HOST=$(oc get route qmgr-demo-ibm-mq-qm -n tools -o jsonpath="{.spec.host}")
########################
# CREATE CCDT #
########################
( echo "cat <<EOF" ; cat templates/template-mq-ccdt.json ;) | \
    QMGR_HOST=${QMGR_HOST} \
    sh > artifacts/MQCCDT.JSON
echo "CCDT has been created."