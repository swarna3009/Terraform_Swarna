
output "vpc_id" {
  description = "Created VPC ID"
  value       = aws_vpc.main.id
}

output "backend_instance_id" {
  description = "Flask EC2 instance ID"
  value       = aws_instance.backend.id
}

output "frontend_instance_id" {
  description = "Express EC2 instance ID"
  value       = aws_instance.frontend.id
}

output "backend_public_ip" {
  description = "Flask public IP"
  value       = aws_instance.backend.public_ip
}

output "backend_private_ip" {
  description = "Flask private IP"
  value       = aws_instance.backend.private_ip
}

output "frontend_public_ip" {
  description = "Express public IP"
  value       = aws_instance.frontend.public_ip
}

output "backend_url" {
  description = "Public Flask API URL"
  value       = "http://${aws_instance.backend.public_ip}:5000/api"
}

output "frontend_url" {
  description = "Public Express frontend URL"
  value       = "http://${aws_instance.frontend.public_ip}:3000"
}
