
variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "flask-express-ecs"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "learning"
}

variable "image_tag" {
  description = "Docker image tag"
  type        = string
  default     = "latest"
}

variable "backend_cpu" {
  description = "Flask Fargate CPU units"
  type        = number
  default     = 256
}

variable "backend_memory" {
  description = "Flask Fargate memory in MiB"
  type        = number
  default     = 512
}

variable "frontend_cpu" {
  description = "Express Fargate CPU units"
  type        = number
  default     = 256
}

variable "frontend_memory" {
  description = "Express Fargate memory in MiB"
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "Number of tasks per ECS service"
  type        = number
  default     = 1
}

variable "log_retention_days" {
  description = "CloudWatch log retention"
  type        = number
  default     = 7
}
