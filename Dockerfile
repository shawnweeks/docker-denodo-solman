FROM openjdk:8-jdk-slim-buster as stage

ENV DENODO_INSTALL_FILE denodo-install-solutionmanager-7.0.zip
ENV DENODO_UPDATE_JAR denodo-solutionmanager-v70-update.jar
ENV DENODO_RESPONSE_FILE response_file_7_0.xml
ENV DENODO_HOME /opt/denodo

# Copy Installation Files
COPY [ "${DENODO_INSTALL_FILE}", "${DENODO_UPDATE_JAR}", "${DENODO_RESPONSE_FILE}", "/tmp/" ]

RUN apt-get update && \
    apt-get install -y unzip && \
    mkdir -p /opt/denodo && \
    unzip /tmp/${DENODO_INSTALL_FILE} -d /tmp && \
    mkdir -p /tmp/denodo-install-solutionmanager-7.0/denodo-update && \
    mv /tmp/${DENODO_UPDATE_JAR} /tmp/denodo-install-solutionmanager-7.0/denodo-update/denodo-update.jar && \
    chmod 755 /tmp/denodo-install-solutionmanager-7.0/*.sh && \
    /tmp/denodo-install-solutionmanager-7.0/installer_cli.sh install --autoinstaller /tmp/response_file_7_0.xml

COPY [ "entrypoint.sh", "configure.sh", "${DENODO_HOME}/" ]

# Custom Version of server.xml to support SSL Enablement at runtime.
COPY [ "tomcat-server.xml", "${DENODO_HOME}/resources/apache-tomcat/conf/server.xml" ]

RUN chmod 755 ${DENODO_HOME}/*.sh

CMD [ "/bin/bash" ]

FROM openjdk:8-jdk-slim-buster

ENV DENODO_HOME /opt/denodo

RUN groupadd -r -g 1001 denodo && \
    useradd -r -u 1001 -g denodo -d ${DENODO_HOME} denodo

COPY --from=stage --chown=denodo:denodo ${DENODO_HOME} ${DENODO_HOME}

USER denodo
WORKDIR ${DENODO_HOME}

# Denodo VQL Server Derby Database
VOLUME ${DENODO_HOME}/metadata/db

# Denodo Solution Manager Derby Database
VOLUME ${DENODO_HOME}/metadata/solution-manager/db

# Denodo Solution Manager Extensions
# Place Oracle JDBC Driver Here
VOLUME ${DENODO_HOME}/lib/solution-manager-extensions

# The following ports are used by the Denodo Solution Manager:
# Server                    Default Port
# Solution Manager Server
# Port                      10090
# License Manager Server
# Port                      10091
# Virtual DataPort Server
# Admin Server/JDBC port    19999
# ODBC port                 19996
# Auxiliary port            19997
# Shutdown port             19998
# SolMan Administration Tool
# HTTP Web container port   19090
# HTTPS Web container port  19443
# Shutdown port             19099
# JMX port                  19098
# Auxiliary JMX port        19097
EXPOSE 10090 10091 19999 19996 19997 19998 19443 19090 19099 19098 19099

ENTRYPOINT [ "./entrypoint.sh" ]