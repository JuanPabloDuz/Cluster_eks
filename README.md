# EKS CLUSTER RUNNING DOCKER IMAGE FROM ECR
## REQUIREMENTS
- [AWS CLI installed](https://aws.amazon.com/es/cli/)
- [Docker installed](https://docs.docker.com/desktop/install/ubuntu/)
- [Kubectl installed](https://kubernetes.io/es/docs/tasks/tools/included/install-kubectl-linux/)
- [Terraform installed](https://developer.hashicorp.com/terraform/install)
- [IAM Permissions](https://docs.aws.amazon.com/eks/latest/userguide/connector-grant-access.html)

## Create an ECR registry & push your image to ECR
[Tutorial](https://docs.aws.amazon.com/AmazonECR/latest/userguide/getting-started-cli.html#cli-create-repository)
## Build a Dockerfile
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
## Terraform
### To create resources run locally:
```bash
git pull
terraform init
terraform plan
terraform apply
```
 Above commands take several minutes to complete and require confirmations
## Configure kubectl
Once new resources are created you will need to modify your ~/.kube/config in certificate-authority-data and server fields according to your cluster data
```bash
aws eks --region us-east-1 update-kubeconfig --name eks-test
```
## Create GitHub Actions Secrets
-KUBE_CONFIG_DATA
-AWS_ACCESS_KEY_ID
-AWS_SECRET_ACCESS_KEY