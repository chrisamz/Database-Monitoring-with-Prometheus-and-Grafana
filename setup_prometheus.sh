#!/bin/bash

# setup_prometheus.sh
# This script sets up Prometheus for monitoring PostgreSQL

# Variables
PROMETHEUS_VERSION="2.26.0"
INSTALL_DIR="/usr/local/prometheus"
CONFIG_DIR="/etc/prometheus"
CONFIG_FILE="$CONFIG_DIR/prometheus.yml"
SERVICE_FILE="/etc/systemd/system/prometheus.service"

# Download and extract Prometheus
echo "Downloading Prometheus..."
wget https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz -O /tmp/prometheus.tar.gz

echo "Extracting Prometheus..."
tar -xvf /tmp/prometheus.tar.gz -C /tmp/
mv /tmp/prometheus-${PROMETHEUS_VERSION}.linux-amd64 $INSTALL_DIR

# Create Prometheus configuration directory
echo "Creating Prometheus configuration directory..."
mkdir -p $CONFIG_DIR

# Copy configuration file
echo "Copying configuration file..."
cp config/prometheus.yml $CONFIG_FILE

# Create Prometheus systemd service file
echo "Creating Prometheus systemd service file..."
cat <<EOT > $SERVICE_FILE
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=root
ExecStart=$INSTALL_DIR/prometheus --config.file=$CONFIG_FILE --storage.tsdb.path=$INSTALL_DIR/data

[Install]
WantedBy=default.target
EOT

# Reload systemd and start Prometheus service
echo "Reloading systemd and starting Prometheus service..."
systemctl daemon-reload
systemctl enable prometheus
systemctl start prometheus

# Clean up
echo "Cleaning up..."
rm /tmp/prometheus.tar.gz

echo "Prometheus setup completed successfully."
