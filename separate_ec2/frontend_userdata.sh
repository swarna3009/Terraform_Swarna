#!/bin/bash
set -euxo pipefail

exec > >(tee -a /var/log/frontend-setup.log) 2>&1

apt-get update -y

apt-get install -y \
  git \
  curl \
  ca-certificates

# Install Node.js 20
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -

apt-get install -y nodejs

# Clone project
if [ ! -d /opt/Terraform_Swarna ]; then
  git clone __REPO_URL__ /opt/Terraform_Swarna
fi

cd /opt/Terraform_Swarna/frontend

# Install exact dependencies from lock file
if [ -f package-lock.json ]; then
  npm ci --omit=dev
else
  npm install --omit=dev
fi

chown -R ubuntu:ubuntu /opt/Terraform_Swarna

# Create systemd service
cat > /etc/systemd/system/express.service <<'EOF'
[Unit]
Description=Express Frontend Application
After=network.target

[Service]
User=ubuntu
WorkingDirectory=/opt/Terraform_Swarna/frontend
Environment=NODE_ENV=production
Environment=API_URL=http://__BACKEND_PRIVATE_IP__:5000/api
ExecStart=/usr/bin/npm start
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable express
systemctl start express
