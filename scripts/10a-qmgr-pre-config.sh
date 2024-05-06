#!/bin/sh
##################################
# QUEUE MANAGER PRECONFIGURATION #
##################################
if [ $(ls artifacts/mq* 2>/dev/null | wc -l) -gt 0 ]
then 
    echo "This script has been executed before."
    echo "If this is a new installation and want to replace existing files, enter <1>"
    echo "If you are re-configuring an existing installation, enter.............. <2>"
    echo "If you want to exit without modifying existing configuration, enter.... <0>"
    read -n 1 -p "Enter option..." USER_OPT
    case "$USER_OPT" in
        1)
            echo "\nDeleting existing files..."
            rm -f artifacts/mq*
            ;;
        2)
            echo "\nDeleting existing files and OCP resources..."
            rm -f artifacts/mq*
            oc delete secret mq-demo-tls-secret -n tools
            oc delete secret mq-demo-tls-secret -n cp4i
            oc delete route qmgr-demo-tls-route -n tools
            ;;
        *)
            echo "\nDo nothing and exit."
            exit 1
            ;;
    esac 
fi
echo "Preconfiguring Queue Manager..."
echo "Creating Certifcate..."
openssl req -config resources/03a-qmgr-tls.conf -newkey rsa -keyout artifacts/qmgr-server-tls.key -x509 -days 365 -out artifacts/qmgr-server-tls.crt
echo "Creating Secrets..."
oc create secret tls mq-demo-tls-secret -n tools --key="artifacts/qmgr-server-tls.key" --cert="artifacts/qmgr-server-tls.crt"
oc -n tools label secret mq-demo-tls-secret assembly.integration.ibm.com/tools.jgr-demo=true
oc create secret tls mq-demo-tls-secret -n cp4i --key="artifacts/qmgr-server-tls.key" --cert="artifacts/qmgr-server-tls.crt"
echo "Creating Route..."
oc create -f resources/03b-qmgr-tls-route.yaml
####################################################################
# This section will create a Trust Store for MQ Explorer           #
# You will need to install MQ Explorer separately if demo required #
####################################################################
echo "Creating TrustStore..."
openssl pkcs12 -export -in artifacts/qmgr-server-tls.crt -inkey artifacts/qmgr-server-tls.key -out artifacts/qmgr-server-tls.p12 -name "qmgr server pkcs12" -passout pass:password
keytool -importkeystore -srckeystore artifacts/qmgr-server-tls.p12 -srcstoretype PKCS12 -srcstorepass password -destkeystore artifacts/mqexplorerts.jks -deststoretype JKS -deststorepass password
##############################################################################################
# This section will create a key store if you plan to demo an external app using the MQI API #
# Just be aware you need to have at least the MQ Client installed in your workstation        #
#
echo "Validating if MQ Client is installed..."
if [ ! command -v runmqakm &> /dev/null ]; then echo "runmqakm could not be found."; exit 1; fi;
echo "Creating KeyStore..."
runmqakm -keydb -create -db artifacts/mqclientkey.kdb -pw password -type cms -stash
runmqakm -cert -add -db artifacts/mqclientkey.kdb -label mqservercert -file artifacts/qmgr-server-tls.crt -format ascii -stashed
#
#######################################################################################
echo "Cleaning up temp files..."
rm -f artifacts/qmgr-server-tls.*
echo "Queue Manager preconfiguration completed."