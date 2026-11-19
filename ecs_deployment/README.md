
# Part 3: Flask and Express on AWS ECS Fargate

## Objective

Deploy Flask and Express as Docker containers using:

- Docker
- Amazon ECR
- Amazon ECS Fargate
- Amazon VPC
- Application Load Balancer
- Terraform
- Amazon S3 remote state
- Amazon CloudWatch

## Architecture

Internet -> Application Load Balancer

- /api and /api/* -> Flask ECS service (port 5000)
- All other paths -> Express ECS service (port 3000)

Both container images are stored in separate ECR repositories.

## Prerequisites

- AWS CLI
- Docker Desktop
- Terraform 1.10 or later
- AWS credentials configured
- Existing Flask and Express applications

## 1. Create Terraform state bucket

Open the bootstrap folder:

```bash
cd bootstrap
terraform init
terraform apply -var="state_bucket_name=YOUR_UNIQUE_BUCKET_NAME"
```

## 2. Configure remote state

Update backend.hcl with the actual bucket name.

From ecs_deployment:

```bash
terraform init -backend-config=backend.hcl
terraform fmt -recursive
terraform validate
```

## 3. Create ECR repositories

```bash
terraform plan -target=aws_ecr_repository.backend -target=aws_ecr_repository.frontend
terraform apply -target=aws_ecr_repository.backend -target=aws_ecr_repository.frontend
```

## 4. Build and push Docker images

Get AWS account ID:

```bash
aws sts get-caller-identity
```

Authenticate Docker to ECR:

```bash
aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin ACCOUNT_ID.dkr.ecr.ap-south-1.amazonaws.com
```

Build backend image:

```bash
docker build -t flask-express-ecs-backend:latest -f backend/Dockerfile ../backend
```

Build frontend image:

```bash
docker build -t flask-express-ecs-frontend:latest -f frontend/Dockerfile ../frontend
```

Tag and push each image using the ECR repository URLs from Terraform outputs:

```bash
terraform output -raw backend_ecr_url
terraform output -raw frontend_ecr_url
```

## 5. Deploy ECS and ALB

After both images have been pushed:

```bash
terraform plan
terraform apply
```

## 6. Verify deployment

```bash
terraform output
aws ecs list-clusters --region ap-south-1
aws ecs list-services --cluster flask-express-ecs-cluster --region ap-south-1
```

Check tasks:

```bash
aws ecs list-tasks --cluster flask-express-ecs-cluster --region ap-south-1
```

Open the ALB URL:

```text
http://ALB_DNS_NAME
```

Test the Flask API:

```text
http://ALB_DNS_NAME/api
```

## 7. View logs

```bash
aws logs tail /ecs/flask-express-ecs/backend --follow --region ap-south-1
aws logs tail /ecs/flask-express-ecs/frontend --follow --region ap-south-1
```

## 8. Cleanup

After completing testing, inspect the resources and run:

```bash
terraform destroy
```

The S3 state bucket is created separately in the bootstrap folder and is not destroyed by this command.

Delete it separately only after the main Terraform state is no longer needed.
