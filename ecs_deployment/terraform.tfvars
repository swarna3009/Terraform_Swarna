
region       = "ap-south-1"
project_name = "flask-express-ecs"
environment  = "learning"
image_tag    = "latest"

backend_cpu    = 256
backend_memory = 512

frontend_cpu    = 256
frontend_memory = 512

desired_count      = 1
log_retention_days = 7
