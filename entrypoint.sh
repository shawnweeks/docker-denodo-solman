#!/bin/bash
set -e

${DENODO_HOME}/configure.sh

startup() {
    echo Starting License Manager
    ${DENODO_HOME}/bin/licensemanager_startup.sh
    echo Starting VQL Server    
    ${DENODO_HOME}/bin/vqlserver_startup.sh
    echo Starting Solution Manager    
    ${DENODO_HOME}/bin/solutionmanager_startup.sh
    echo Starting Solution Manager Web Tool
    ${DENODO_HOME}/bin/solutionmanagerwebtool_startup.sh
    tail -n +1 -F ${DENODO_HOME}/logs/*/*.log
}

shutdown() {
     echo Stopping Solution Manager Web Tool
    ${DENODO_HOME}/bin/solutionmanagerwebtool_shutdown.sh
    echo Stopping Solution Manager
    ${DENODO_HOME}/bin/solutionmanager_shutdown.sh
    echo Stopping VQL Server
    ${DENODO_HOME}/bin/vqlserver_shutdown.sh
    echo Stopping License Manager
    ${DENODO_HOME}/bin/licensemanager_shutdown.sh
}

trap "shutdown" INT
startup