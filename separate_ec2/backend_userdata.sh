#!/bin/bash
set -euxo pipefail

exec > >(tee -a /var/log/backend-setup.log) 2>&1

apt-get update -y

apt-get install -y \
  git \
  python3 \
  python3-pip \
  python3-venv

# Clone project
if [ ! -d /opt/Terraform_Swarna ]; then
  git clone https://github.com/swarna3009/Terraform_Swarna.git \
    /opt/Terraform_Swarna
fi

cd /opt/Terraform_Swarna/backend

# Create Python virtual environment
python3 -m venv venv

# Install project dependencies
if [ -f requirements.txt ]; then
  venv/bin/pip install -r requirements.txt
else
  venv/bin/pip install flask
fi

# Ensure Gunicorn is installed
venv/bin/pip install gunicorn

chown -R ubuntu:ubuntu /opt/Terraform_Swarna

# Create systemd service
cat > /etc/systemd/system/flask.service <<'EOF'
[Unit]
Description=Flask Backend Application
After=network.target

[Service]
User=ubuntu
WorkingDirectory=/opt/Terraform_Swarna/backend
ExecStart=/opt/Terraform_Swarna/backend/venv/bin/gunicorn --workers 2 --bind 0.0.0.0:5000 app:app
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable flask
systemctl start flask
