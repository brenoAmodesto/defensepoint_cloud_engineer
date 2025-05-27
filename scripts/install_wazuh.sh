#!/bin/bash
# Update and install Docker
yum update -y
amazon-linux-extras install docker -y
systemctl enable docker
systemctl start docker

# Install Docker Compose
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# Enable and start rsyslog for basic logging
yum install -y rsyslog
systemctl enable rsyslog
systemctl start rsyslog

# Create Wazuh directory
mkdir -p /opt/wazuh

# Copy docker-compose.yml
cat > /opt/wazuh/docker-compose.yml <<EOF
${docker_compose}
EOF

cd /opt/wazuh
docker-compose up -d