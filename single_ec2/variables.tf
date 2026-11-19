
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Existing EC2 key pair name"
  type        = string
}

variable "ssh_cidr" {
  description = "Your public IP address with /32"
  type        = string
}

variable "github_repo_url" {
  description = "GitHub repository URL"
  type        = string
}
