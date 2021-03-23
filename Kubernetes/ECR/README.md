# Amazon Elastic Container Registry (ECR)
Amazon Elastic Container Registry (ECR) is a fully managed container registry that makes it easy to store, manage, share, and deploy your container images and artifacts anywhere. 

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

