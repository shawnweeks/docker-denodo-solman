# Docker Image for Denodo Solution Manager 7
To complete and run this build you will need the following files.
1. denodo-install-solutionmanager-7.0.zip
2. denodo-solutionmanager-v70-update.jar for the latest patch.
3. Valid Denodo Solution Manager License - Express will not work.

### Build Image
```shell
docker build -t denodo-solman:latest .
```

### Without SSL
```shell
docker run -it \
    --name denodo \
    -p 10090:10090 \
    -p 10091:10091 \
    -p 19090:19090 \
    -v $(pwd)/denodo.lic:/opt/denodo/conf/denodo.lic \
    -v denodo_vdp_db_volume:/opt/denodo/metadata/db \
    -v denodo_solman_db_volume:/metadata/solution-manager/db \
    denodo-solman:latest
```

### With SSL
```shell
docker run -it \
    --name denodo \
    -p 10090:10090 \
    -p 10091:10091 \
    -p 19443:19443 \
    -v $(pwd)/denodo.lic:/opt/denodo/conf/denodo.lic \
    -v denodo_vdp_db_volume:/opt/denodo/metadata/db \
    -v denodo_solman_db_volume:/metadata/solution-manager/db \
    -v $(pwd)/keystore.jks:/opt/denodo/keystore.jks \
    -v $(pwd)/truststore.jks:/opt/denodo/truststore.jks \
    -e DENODO_SSL_ENABLED="true" \
    -e DENODO_SSL_KEYSTORE="/opt/denodo/keystore.jks" \
    -e DENODO_SSL_KEYSTORE_PASS="changeit" \
    -e DENODO_SSL_TRUSTSTORE="/opt/denodo/keystore.jks" \
    -e DENODO_SSL_TRUSTSTORE_PASS="changeit" \
    denodo-solman:latest
```

If SSL is enabled HTTP is disabled in this build.

HTTPS URL: http://localhost:19090/solution-manager-web-tool/  
HTTPS URL: https://localhost:19443/solution-manager-web-tool/  
Username: admin  
Password: admin  