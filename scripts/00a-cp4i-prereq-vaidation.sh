#!/bin/sh
# This script requires the oc command being installed in your environment
if [ ! command -v oc &> /dev/null ]; then echo "oc could not be found"; exit 1; fi;
if [ ! command -v zip &> /dev/null ]; then echo "zip could not be found"; exit 1; fi;
if [ ! command -v keytool &> /dev/null ]; then echo "keytool could not be found"; exit 1; fi;
if [ ! command -v openssl &> /dev/null ]; then echo "openssl could not be found"; exit 1; fi;
if [ ! command -v jq &> /dev/null ]; then echo "jq could not be found"; exit 1; fi;
if [ ! command -v yq &> /dev/null ]; then echo "yq could not be found"; exit 1; fi;
if [ ! command -v awk &> /dev/null ]; then echo "awk could not be found"; exit 1; fi;
if [ ! command -v apic &> /dev/null ]; then echo "apic could not be found"; exit 1; fi;
echo "The minimum Pre-requisites are met to use this repo."
if [ ! command -v podman &> /dev/null ]; then echo "podman could not be found"; exit 1; fi;
if [ ! command -v runmqakm &> /dev/null ]; then echo "runmqakm could not be found"; exit 1; fi;
echo "The optional pre-requisites are met as well, you can use the EEM section if you want to."
if [ -z "$OCP_TYPE" ]; then echo "OCP_TYPE not set, it must be provided on the command line."; exit 1; fi;
if [ -z "$CP4I_VER" ]; then echo "CP4I_VER not set, it must be provided on the command line."; exit 1; fi;
echo "OCP_TYPE has been set to " $OCP_TYPE
echo "CP4I_VER has been set to " $CP4I_VER
if [ -z "$CP4I_TRACING" ]; then echo "CP4I Tracing is enabled"; else echo "CP4I Tracing is NOT eabled"; fi;
echo "You are ready to start. Have fun!"