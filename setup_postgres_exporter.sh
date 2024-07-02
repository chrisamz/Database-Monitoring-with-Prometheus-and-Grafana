#!/bin/bash

# setup_postgres_exporter.sh
# This script sets up the PostgreSQL exporter for Prometheus

# Variables
EXPORTER_VERSION="0.8.0"
INSTALL_DIR="/usr/local/postgres_exporter"
CONFIG_FILE="$INSTALL_DIR/postgres_exporter.yml"
SERVICE_FILE="/etc/systemd/system/postgres_exporter.service"
POSTGRES_USER="username"
POSTGRES_PASSWORD="password"
POSTGRES_DB="postgres"
POSTGRES_HOST="localhost"
POSTGRES_PORT="5432"

# Download and extract PostgreSQL exporter
echo "Downloading PostgreSQL exporter..."
wget https://github.com/prometheus-community/postgres_exporter/releases/download/v${EXPORTER_VERSION}/postgres_exporter-${EXPORTER_VERSION}.linux-amd64.tar.gz -O /tmp/postgres_exporter.tar.gz

echo "Extracting PostgreSQL exporter..."
tar -xvf /tmp/postgres_exporter.tar.gz -C /tmp/
mv /tmp/postgres_exporter-${EXPORTER_VERSION}.linux-amd64 $INSTALL_DIR

# Create PostgreSQL exporter configuration file
echo "Creating PostgreSQL exporter configuration file..."
cat <<EOT > $CONFIG_FILE
data_source_name: "postgresql://$POSTGRES_USER:$POSTGRES_PASSWORD@$POSTGRES_HOST:$POSTGRES_PORT/$POSTGRES_DB?sslmode=disable"
EOT

# Create PostgreSQL exporter systemd service file
echo "Creating PostgreSQL exporter systemd service file..."
cat <<EOT > $SERVICE_FILE
[Unit]
Description=PostgreSQL Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=root
Environment=DATA_SOURCE_NAME=postgresql://$POSTGRES_USER:$POSTGRES_PASSWORD@$POSTGRES_HOST:$POSTGRES_PORT/$POSTGRES_DB?sslmode=disable
ExecStart=$INSTALL_DIR/postgres_exporter --config.file=$CONFIG_FILE

[Install]
WantedBy=default.target
EOT

# Reload systemd and start PostgreSQL exporter service
echo "Reloading systemd and starting PostgreSQL exporter service..."
systemctl daemon-reload
systemctl enable postgres_exporter
systemctl start postgres_exporter

# Clean up
echo "Cleaning up..."
rm /tmp/postgres_exporter.tar.gz

echo "PostgreSQL exporter setup completed successfully."
