
variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "flask-express-separate"
}

variable "key_name" {
  description = "Existing AWS EC2 key pair"
  type        = string
}

variable "ssh_cidr" {
  description = "Public IP allowed to SSH"
  type        = string
}

variable "repo_url" {
  description = "GitHub repository URL"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}
