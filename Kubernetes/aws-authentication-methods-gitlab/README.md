# AWS Authentication in GitLab

## Methods
	1. [Adding Required Variables to GitLab](https://github.com/BBRathnayaka/Kubernetes-Docker/tree/master/Kubernetes/aws-authentication-methods-gitlab#normal-way-of-authenticating-aws-services---ecreks-in-gitlab)
	2. Mount aws conf to GitLab Runner volumes [config.toml]
	3. Create a AWS role with full access policy 


### Normal way of authenticating AWS services - ECR,EKS in GitLab

Use like this in your `.gitlab-ci.yml` :

```yml
---
variables:
  DOCKER_REGISTRY: 085813410481.dkr.ecr.us-west-2.amazonaws.com
  AWS_DEFAULT_REGION: us-west-2
  APP_NAME: eme-site
  DOCKER_HOST: tcp://docker:2375

publish_to_ECR:
  stage: publish
  image: 
    name: amazon/aws-cli
    entrypoint: [""]
  services:
    - docker:18.09-dind
  before_script:
    - amazon-linux-extras install docker
    - aws --version
    - docker --version
  script:
    - docker build -t $DOCKER_REGISTRY/$APP_NAME:$CI_PIPELINE_IID src/. 
    - aws ecr get-login-password | docker login --username AWS --password-stdin $DOCKER_REGISTRY
    - docker push $DOCKER_REGISTRY/$APP_NAME:$CI_PIPELINE_IID
    - echo "Pushed $DOCKER_REGISTRY/$APP_NAME:$CI_PIPELINE_IID to ECR "
  only:
  - master

k8s-deploy:
  stage: deploy
  image: dtzar/helm-kubectl
  script:
    - kubectl config set-cluster k8s --server="${SERVER}"
    - kubectl config set clusters.k8s.certificate-authority-data ${CERTIFICATE_AUTHORITY_DATA}
    - kubectl config set-credentials gitlab --token="${USER_TOKEN}"
    - kubectl config set-context default --cluster=k8s --user=gitlab
    - kubectl config use-context default
    - export OUTPUT=$(kubectl version --short)
    - echo $OUTPUT
    - sed -i "s/<VERSION>/${CI_PIPELINE_IID}/g" deployments/deploy.yml
    - kubectl apply -f deployments/deploy.yml 
```

To perform authentication with only gitlab , we need to add variables to gitlab project,

Administrator -> project -> CI/CD Settings -> Varibales ->
- `AWS_ACCESS_KEY_ID = xxxx` 
- `AWS_SECRET_ACCESS_KEY = xxxx`
- `CERTIFICATE_AUTHORITY_DATA = xxxx`
- `CLUSTER_NAME = xxxx`
- `SERVER = xxxx`
- `USER_TOKEN = xxxx`





#### How it Works 
<p align="center">
  <img src="https://d1.awsstatic.com/diagrams/product-page-diagrams/Product-Page-Diagram_Amazon-ECR.bf2e7a03447ed3aba97a70e5f4aead46a5e04547.png" >
</p>


### Create a repository
Create a repository in a available zone with private visibility. 
Provide a concise name. A developer should be able to identify the repository contents by the name.
Tag immutability should be enabled to avoid pushing images with same tag. 

### Gitlab ECR settings
In order to push build images to ECR, Variables should be added as follows in following location,

Administrator -> project -> CI/CD Settings -> Varibales ->
- `AWS_ACCESS_KEY_ID = xxxx` 
- `AWS_SECRET_ACCESS_KEY = xxxx`

