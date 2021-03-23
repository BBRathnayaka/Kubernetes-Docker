# Nginx-Proxy

### Why proxy ?
A reverse proxy intercepts incoming requests and directs them to the appropriate server. Not only does this speed up performance, it also strengthens server security.

### docker-compose file
This repository includes certificates & conf files for each domain. These are mounted to nginx-proxy,
```sh
    volumes:
      - ./conf:/etc/nginx/conf.d
      - ./certificates:/etc/nginx/certificates
```

### Update openSSL config File 
```sh
docker run --rm -v ${PWD}:/work -it nginx /bin/bash -c "sed -i 's/DNS.1.*/DNS.1 = local.emarketingeye.com/g' /work/openssl.cnf && sed -i 's/DNS.2.*/DNS.2 = *.local.emarketingeye.com/g' /work/openssl.cnf"
```

### Generate Certificates
```sh
docker run --rm -v ${PWD}:/work -it nginx /bin/bash -c "openssl genrsa -out /work/local.emarketingeye.com/local.emarketingeye.com.key 2048 && openssl req -subj '/CN=local.emarketingeye.com' -new -sha256 -key /work/local.emarketingeye.com/local.emarketingeye.com.key -out /work/local.emarketingeye.com/local.emarketingeye.com.csr -config /work/openssl.cnf && openssl x509 -req -days 3650 -in /work/local.emarketingeye.com/local.emarketingeye.com.csr -signkey /work/local.emarketingeye.com/local.emarketingeye.com.key -out /work/local.emarketingeye.com/local.emarketingeye.com.crt -extensions v3_req -extfile /work/openssl.cnf"
```

