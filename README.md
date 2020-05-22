Example Docker for Denodo Solution Manager 7

### Build Image
```shell
docker build -t denodo-solman:latest .
```

### Without SSL
```shell
docker run -it \
    --name denodo \
    -p 19090:19090 -p 10090:10090 \
    -v $(pwd)/denodo.lic:/opt/denodo/conf/denodo.lic \
    -v denodo_vdp_db_volume:/opt/denodo/metadata/db \
    -v denodo_solman_db_volume:/metadata/solution-manager/db \
    denodo-solman:latest
```

### With SSL
```shell
docker run -it \
    --name denodo \
    -p 19090:19090 -p 10090:10090 \
    -v $(pwd)/denodo.lic:/opt/denodo/conf/denodo.lic \
    -v denodo_vdp_db_volume:/opt/denodo/metadata/db \
    -v denodo_solman_db_volume:/metadata/solution-manager/db \
    -v $(pwd)/keystore.jks:/opt/denodo/keystore.jks \
    -e DENODO_SSL_ENABLED="true" \
    -e DENODO_SSL_KEYSTORE="keystore.jks" \
    -e DENODO_SSL_KEYSTORE_PASS="changeit" \
    -e DENODO_SSL_TRUSTSTORE="keystore.jks" \
    -e DENODO_SSL_TRUSTSTORE_PASS="changeit" \
    denodo-solman:latest
```
URL: http://localhost:19090/solution-manager-web-tool/Home.html  
Username: admin  
Password: admin  