#!/bin/bash

replaceProperty() {
    local file=$1
    local key=$2
    local value=$3

    if ! grep -R "^[#]*\s*${key}=.*" ${file} > /dev/null; then
        echo "APPENDING because '${key}' not found"
        echo "${key}=${value}" >> ${file}
    else
        echo "SETTING because '${key}' found already"
        sed -ir "s~^[#]*\s*${key}=.*~${key}=${value}~" ${file}
    fi
}

# Enable Security Features
# DENODO_SSL_ENABLED
# DENODO_SSL_KEYSTORE
# DENODO_SSL_KEYSTORE_PASS
# DENODO_SSL_TRUSTSTORE
# DENODO_SSL_TRUSTSTORE_PASS
setupSecurity() {
    local VP=${DENODO_HOME}/conf/vdp/VDBConfiguration.properties
    local SP=${DENODO_HOME}/conf/solution-manager/SMConfigurationParameters.properties
    if [[ ${DENODO_SSL_ENABLED:=false} = true ]]
    then
        echo "INFO: Enabling SSL"
        if [[ -z $DENODO_SSL_KEYSTORE || -z  $DENODO_SSL_KEYSTORE_PASS || -z $DENODO_SSL_TRUSTSTORE || -z $DENODO_SSL_TRUSTSTORE_PASS ]]
        then
            echo "ERROR: Missing Required Denodo SSL Parameters"
            echo "ERROR: DENODO_SSL_KEYSTORE, DENODO_SSL_KEYSTORE_PASS, DENODO_SSL_TRUSTSTORE and DENODO_SSL_TRUSTSTORE_PASS are required."
            exit 1
        else
            replaceProperty ${VP} com.denodo.security.ssl.enabled ${DENODO_SSL_ENABLED}
            replaceProperty ${VP} com.denodo.security.ssl.keyStore ${DENODO_SSL_KEYSTORE}
            replaceProperty ${VP} com.denodo.security.ssl.keyStorePassword ${DENODO_SSL_KEYSTORE_PASS}
            replaceProperty ${VP} com.denodo.security.ssl.trustStore ${DENODO_SSL_TRUSTSTORE}
            replaceProperty ${VP} com.denodo.security.ssl.trustStorePassword ${DENODO_SSL_TRUSTSTORE_PASS}

            replaceProperty ${SP} server.ssl.key-store ${DENODO_SSL_KEYSTORE}
            replaceProperty ${SP} server.ssl.key-store-password ${DENODO_SSL_KEYSTORE_PASS}
            replaceProperty ${SP} com.denodo.security.ssl.trustStore ${DENODO_SSL_TRUSTSTORE}
            replaceProperty ${SP} com.denodo.security.ssl.trustStorePassword ${DENODO_SSL_TRUSTSTORE_PASS}            
        fi
    else
        return 0
    fi
}

setupSecurity