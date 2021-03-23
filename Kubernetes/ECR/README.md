# Nginx-Proxy

### Amazon Elastic Container Registry (ECR)
Amazon Elastic Container Registry (ECR) is a fully managed container registry that makes it easy to store, manage, share, and deploy your container images and artifacts anywhere. 

<p align="center">
  <img src="https://d1.awsstatic.com/diagrams/product-page-diagrams/Product-Page-Diagram_Amazon-ECR.bf2e7a03447ed3aba97a70e5f4aead46a5e04547.png" >
</p>


### docker-compose file
This repository includes certificates & conf files for each domain. These are mounted to nginx-proxy,
```sh
    volumes:
      - ./conf:/etc/nginx/conf.d
      - ./certificates:/etc/nginx/certificates
```

First,Create a sub-folder named domain in the certificate folder.

### 1. Update openSSL config File
```sh
docker run --rm -v ${PWD}:/work -it nginx /bin/bash -c "sed -i 's/DNS.1.*/DNS.1 = local.emarketingeye.com/g' /work/openssl.cnf && sed -i 's/DNS.2.*/DNS.2 = *.local.emarketingeye.com/g' /work/openssl.cnf"
```

### 2. Generate Certificates
```sh
docker run --rm -v ${PWD}:/work -it nginx /bin/bash -c "openssl genrsa -out /work/local.emarketingeye.com/local.emarketingeye.com.key 2048 && openssl req -subj '/CN=local.emarketingeye.com' -new -sha256 -key /work/local.emarketingeye.com/local.emarketingeye.com.key -out /work/local.emarketingeye.com/local.emarketingeye.com.csr -config /work/openssl.cnf && openssl x509 -req -days 3650 -in /work/local.emarketingeye.com/local.emarketingeye.com.csr -signkey /work/local.emarketingeye.com/local.emarketingeye.com.key -out /work/local.emarketingeye.com/local.emarketingeye.com.crt -extensions v3_req -extfile /work/openssl.cnf"
```
This generated certificates are stored in the above made directory. 

### 3. Install Certificates
1. Windows 

2. Debian

### 4. Enable HTTPS
Create .conf file for the required domain
- `If https is needed add .conf file to conf directory`
- `Remove .conf file from conf directory if https is not needed`

### 5. Run docker-compose file