#!/bin/bash

# setup_grafana.sh
# This script sets up Grafana for visualizing PostgreSQL metrics

# Variables
GRAFANA_VERSION="7.5.1"
INSTALL_DIR="/usr/local/grafana"
SERVICE_FILE="/etc/systemd/system/grafana.service"

# Download and extract Grafana
echo "Downloading Grafana..."
wget https://dl.grafana.com/oss/release/grafana-${GRAFANA_VERSION}.linux-amd64.tar.gz -O /tmp/grafana.tar.gz

echo "Extracting Grafana..."
tar -zxvf /tmp/grafana.tar.gz -C /tmp/
mv /tmp/grafana-${GRAFANA_VERSION} $INSTALL_DIR

# Create Grafana systemd service file
echo "Creating Grafana systemd service file..."
cat <<EOT > $SERVICE_FILE
[Unit]
Description=Grafana
Wants=network-online.target
After=network-online.target

[Service]
User=root
ExecStart=$INSTALL_DIR/bin/grafana-server --config=$INSTALL_DIR/conf/defaults.ini --homepath=$INSTALL_DIR

[Install]
WantedBy=default.target
EOT

# Reload systemd and start Grafana service
echo "Reloading systemd and starting Grafana service..."
systemctl daemon-reload
systemctl enable grafana
systemctl start grafana

# Clean up
echo "Cleaning up..."
rm /tmp/grafana.tar.gz

echo "Grafana setup completed successfully. Access Grafana at http://localhost:3000"
