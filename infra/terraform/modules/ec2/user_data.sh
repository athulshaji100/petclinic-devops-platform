#!/bin/bash

# Update
apt update -y

# Git
apt install -y git

# Java 17 and 21
apt install -y openjdk-17-jdk openjdk-21-jdk

# Maven
apt install -y maven

# Docker
curl -fsSL https://get.docker.com | sh
usermod -aG docker ubuntu

# AWS CLI
apt install -y unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
cd /tmp
unzip -o awscliv2.zip
./aws/install

# kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /usr/local/bin/

# Helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Terraform
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com noble main" > /etc/apt/sources.list.d/hashicorp.list

apt update -y
apt install -y terraform

# Jenkins
mkdir -p /etc/apt/keyrings

wget -O /etc/apt/keyrings/jenkins-keyring.asc \
https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key

echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" \
> /etc/apt/sources.list.d/jenkins.list

apt update -y
apt install -y jenkins

# Docker permissions for Jenkins
usermod -aG docker jenkins

# Start Jenkins
systemctl enable jenkins
systemctl start jenkins


# =========================
# PostgreSQL for SonarQube
# =========================

apt update -y
apt install -y postgresql postgresql-contrib unzip wget

systemctl enable postgresql
systemctl start postgresql

# Create SonarQube DB/User safely
sudo -u postgres psql <<'EOF'
DO
$do$
BEGIN
   IF NOT EXISTS (
      SELECT FROM pg_catalog.pg_roles WHERE rolname = 'sonar'
   ) THEN
      CREATE ROLE sonar LOGIN ENCRYPTED PASSWORD 'sonar123';
   END IF;
END
$do$;
EOF

sudo -u postgres psql <<'EOF'
SELECT 'CREATE DATABASE sonarqube OWNER sonar'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'sonarqube')\gexec
EOF

# Fix schema permissions
sudo -u postgres psql -d sonarqube <<'EOF'
ALTER DATABASE sonarqube OWNER TO sonar;
ALTER SCHEMA public OWNER TO sonar;
GRANT ALL ON SCHEMA public TO sonar;
GRANT ALL PRIVILEGES ON DATABASE sonarqube TO sonar;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO sonar;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO sonar;
EOF

# =========================
# SonarQube Install
# =========================

cd /opt

if [ ! -d "/opt/sonarqube" ]; then
  wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-25.8.0.112029.zip
  unzip sonarqube-25.8.0.112029.zip
  mv sonarqube-25.8.0.112029 sonarqube
fi

# Create Sonar Linux User safely
id -u sonar &>/dev/null || useradd -r -s /bin/bash sonar

chown -R sonar:sonar /opt/sonarqube

# =========================
# SonarQube DB Config
# =========================

cat > /opt/sonarqube/conf/sonar.properties <<'EOF'
sonar.jdbc.username=sonar
sonar.jdbc.password=sonar123
sonar.jdbc.url=jdbc:postgresql://localhost:5432/sonarqube
EOF

# =========================
# Linux Kernel Settings
# =========================

grep -q "vm.max_map_count=524288" /etc/sysctl.conf || echo "vm.max_map_count=524288" >> /etc/sysctl.conf
grep -q "fs.file-max=131072" /etc/sysctl.conf || echo "fs.file-max=131072" >> /etc/sysctl.conf

sysctl -p

# =========================
# SonarQube Service
# =========================

cat > /etc/systemd/system/sonarqube.service <<'EOF'
[Unit]
Description=SonarQube
After=network.target postgresql.service

[Service]
Type=forking

User=sonar
Group=sonar

ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop

Restart=always

LimitNOFILE=131072
LimitNPROC=8192

[Install]
WantedBy=multi-user.target
EOF

# =========================
# Start SonarQube
# =========================

systemctl daemon-reload
systemctl enable sonarqube
systemctl restart sonarqube

# =========================
# Check Status
# =========================

sleep 30

systemctl status sonarqube --no-pager

echo "======================================="
echo "SonarQube : http://<EC2-PUBLIC-IP>:9000"
echo "Username  : admin"
echo "Password  : admin"
echo "======================================="


# =========================
# Display URLs
# =========================

echo "======================================="
echo "Jenkins  : http://<EC2-PUBLIC-IP>:8080"
echo "SonarQube: http://<EC2-PUBLIC-IP>:9000"
echo "======================================="    


# =========================
# Trivy-Installation
# =========================

sudo apt-get update
sudo apt-get install -y wget apt-transport-https gnupg lsb-release

wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/trivy.gpg > /dev/null

echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | \
sudo tee /etc/apt/sources.list.d/trivy.list

sudo apt-get update
sudo apt-get install -y trivy


