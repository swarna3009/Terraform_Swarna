#!/bin/bash
set -euxo pipefail

# Log all commands and errors
exec > /var/log/user-data.log 2>&1

echo "===== USER DATA STARTED ====="

# 1. Update Ubuntu packages
apt-get update -y

# 2. Install required packages
apt-get install -y \
    git \
    curl \
    ca-certificates \
    python3 \
    python3-venv \
    python3-pip

# 3. Install Node.js 20
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt-get install -y nodejs

# 4. Verify installations
python3 --version
node --version
npm --version

# 5. Clone GitHub repository
mkdir -p /opt
git clone "${github_repo_url}" /opt/Terraform_Swarna

# 6. Install Flask backend dependencies
cd /opt/Terraform_Swarna/backend

python3 -m venv venv

./venv/bin/pip install --upgrade pip
./venv/bin/pip install -r requirements.txt
./venv/bin/pip install gunicorn

# 7. Install Express frontend dependencies
cd /opt/Terraform_Swarna/frontend

npm ci --omit=dev

# 8. Set correct ownership
chown -R ubuntu:ubuntu /opt/Terraform_Swarna

# 9. Create Flask systemd service
cat > /etc/systemd/system/flask.service <<'EOF'
[Unit]
Description=Flask Backend
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

# 10. Create Express systemd service
cat > /etc/systemd/system/express.service <<'EOF'
[Unit]
Description=Express Frontend
After=network.target flask.service

[Service]
User=ubuntu
WorkingDirectory=/opt/Terraform_Swarna/frontend
Environment=API_URL=http://127.0.0.1:5000/api
ExecStart=/usr/bin/npm start
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# 11. Reload systemd
systemctl daemon-reload

# 12. Enable services at boot
systemctl enable flask.service
systemctl enable express.service

# 13. Start Flask backend
systemctl start flask.service

# 14. Start Express frontend
systemctl start express.service

# 15. Verify both services
systemctl is-active flask.service
systemctl is-active express.service

echo "===== USER DATA COMPLETED SUCCESSFULLY ====="
