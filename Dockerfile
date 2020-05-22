FROM openjdk:8-jdk-slim-buster as stage

ENV DENODO_INSTALL_FILE denodo-install-solutionmanager-7.0.zip
ENV DENODO_UPDATE_JAR denodo-solutionmanager-v70-update-202003102200.jar
ENV DENODO_RESPONSE_FILE response_file_7_0.xml

COPY [ "$DENODO_INSTALL_FILE", "$DENODO_UPDATE_JAR", "$DENODO_RESPONSE_FILE", "/tmp/" ]

RUN apt-get update && \
    apt-get install -y unzip && \
    mkdir -p /opt/denodo && \
    unzip /tmp/$DENODO_INSTALL_FILE -d /tmp && \
    mkdir -p /tmp/denodo-install-solutionmanager-7.0/denodo-update && \
    mv /tmp/$DENODO_UPDATE_JAR /tmp/denodo-install-solutionmanager-7.0/denodo-update/denodo-update.jar && \
    chmod 755 /tmp/denodo-install-solutionmanager-7.0/*.sh && \
    /tmp/denodo-install-solutionmanager-7.0/installer_cli.sh install --autoinstaller /tmp/response_file_7_0.xml

CMD [ "/bin/bash" ]