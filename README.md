# EKS CLUSTER RUNNING DOCKER IMAGE FROM ECR
The aim of this repository is to solve a simple task: using terraform to build EKS infra to run a basic flask python 'Hello World' with CI/CD using GitHub Actions.

The code is organized in folders:

- Cluster_EKS
   -  _Dockerfile                     (for the - - -  first build)
   - main.tf                        (terraform main)
   - _provider.tf                    (set here your - region and AWS credentials)
   - _.github/workflows/deploy.yml   (GitHub Actions)
   - _app/helow.py                   (main Python Hellow World)
   - _tests/test_hellow.py           (tests)
   - _modules/vpc                    (terraform VPC resources)

## Requirements
- [AWS CLI installed](https://aws.amazon.com/es/cli/)
- [Docker installed](https://docs.docker.com/desktop/install/ubuntu/)
- [Kubectl installed](https://kubernetes.io/es/docs/tasks/tools/included/install-kubectl-linux/)
- [Terraform installed](https://developer.hashicorp.com/terraform/install)
- [IAM Permissions](https://docs.aws.amazon.com/eks/latest/userguide/connector-grant-access.html)

## 1 Create an ECR registry & push your image to ECR
[Tutorial](https://docs.aws.amazon.com/AmazonECR/latest/userguide/getting-started-cli.html#cli-create-repository)
## 2 Build Image
Run this commands in your local environmet for the first image.  
### Create a Dockerfile:
```bash
cat << EOF > Dockerfile
FROM python:3.9-slim
WORKDIR /app
COPY app.py .
CMD ["python", "app.py"]
EOF
```
### Build your image
```bash
docker build -t my_apache_image .
```
### Test locally
```bash
docker run -d -p 80:80 my_apache_image 
```
### Tag your app image
Replace '123456789101112' whith your AWS Account ID and use the name of your app image here too:
```bash
docker tag your-app-image-name:latest 123456789101112.dkr.ecr.us-east-1.amazonaws.com/your-app-image-name 
```
### Loggin to ECR 
```bash
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 123456789101112.dkr.ecr.us-east-1.amazonaws.com/your-app-image-name /
```
### Push your image to ECR
```bash
docker push 123456789101112.dkr.ecr.us-east-1.amazonaws.com/your-app-image-name
```
## 3 Deploy infra using terraform
### To create resources run locally:
```bash
git pull
terraform init
terraform plan
terraform apply
```
 Above commands take several minutes to complete and require confirmations.

 Terraform code is based on AWS offical module for EKS and add-ons blueprints:

https://github.com/aws-ia/terraform-aws-eks-blueprints-addons
https://github.com/terraform-aws-modules/terraform-aws-eks/tree/v18.26.6/examples/complete

## 4 Configure kubectl
Once new resources are created you will need to modify your ~/.kube/config in certificate-authority-data and server fields according to your cluster data. Check here your cluster's region.
```bash
aws eks --region us-east-1 update-kubeconfig --name eks-test
```
## 5 Create GitHub Actions Secrets
In order to grant GitHub permissions to acces AWS and the cluster, creating the following secrets:

- KUBE_CONFIG_DATA (.kube/config)
- AWS_ACCESS_KEY_ID (.aws/credentials)
- AWS_SECRET_ACCESS_KEY (.aws/credentials)

See https://docs.github.com/en/actions/security-guides/using-secrets-in-github-actions

## 6 Test automations
Make any change in the python code will run a job that builds a new image and uploads it to ECR to be available for the deployment.yaml to be used at your cluster.  