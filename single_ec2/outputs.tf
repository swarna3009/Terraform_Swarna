
output "instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.app_server.id
}

output "public_ip" {
  description = "EC2 Public IP"
  value       = aws_instance.app_server.public_ip
}

output "frontend_url" {
  description = "Express Frontend URL"
  value       = "http://${aws_instance.app_server.public_ip}:3000"
}

output "backend_url" {
  description = "Flask Backend URL"
  value       = "http://${aws_instance.app_server.public_ip}:5000/api"
}
