# Database Monitoring with Prometheus and Grafana

## Overview

This project focuses on setting up a monitoring system for a PostgreSQL database using Prometheus and Grafana. The system includes monitoring configuration, custom dashboards, alerting rules, and performance metrics to ensure optimal database performance and availability.

## Technologies

- PostgreSQL
- Prometheus
- Grafana

## Key Features

- Monitoring configuration for PostgreSQL
- Custom Grafana dashboards for visualizing database performance
- Prometheus alerting rules for proactive monitoring
- Collection and display of key performance metrics

## Project Structure

```
database-monitoring/
├── config/
│   ├── prometheus.yml
│   ├── postgres_exporter.yml
├── dashboards/
│   ├── postgres_dashboard.json
├── scripts/
│   ├── setup_prometheus.sh
│   ├── setup_grafana.sh
│   ├── setup_postgres_exporter.sh
├── alerts/
│   ├── alert_rules.yml
├── docs/
│   ├── setup_guide.md
│   ├── dashboard_guide.md
│   ├── alerting_guide.md
├── README.md
└── LICENSE
```

## Instructions

### 1. Clone the Repository

Start by cloning the repository to your local machine:

```bash
git clone https://github.com/your-username/database-monitoring.git
cd database-monitoring
```

### 2. Set Up Prometheus

Use the `setup_prometheus.sh` script to set up Prometheus.

#### Configuration File: `prometheus.yml`

```yaml
# prometheus.yml
# Prometheus configuration for scraping PostgreSQL metrics

global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'postgres'
    static_configs:
      - targets: ['localhost:9187']
    metrics_path: /metrics
    scheme: http
```

#### Script: `setup_prometheus.sh`

```bash
#!/bin/bash

# setup_prometheus.sh
# This script sets up Prometheus for monitoring PostgreSQL

# Install Prometheus
wget https://github.com/prometheus/prometheus/releases/download/v2.26.0/prometheus-2.26.0.linux-amd64.tar.gz
tar -xvf prometheus-2.26.0.linux-amd64.tar.gz
mv prometheus-2.26.0.linux-amd64 /usr/local/prometheus

# Copy configuration file
cp config/prometheus.yml /usr/local/prometheus/prometheus.yml

# Start Prometheus
/usr/local/prometheus/prometheus --config.file=/usr/local/prometheus/prometheus.yml &
```

### 3. Set Up PostgreSQL Exporter

Use the `setup_postgres_exporter.sh` script to set up the PostgreSQL exporter.

#### Configuration File: `postgres_exporter.yml`

```yaml
# postgres_exporter.yml
# PostgreSQL exporter configuration

postgres_exporter:
  data_source_name: "postgresql://username:password@localhost:5432/postgres?sslmode=disable"
```

#### Script: `setup_postgres_exporter.sh`

```bash
#!/bin/bash

# setup_postgres_exporter.sh
# This script sets up the PostgreSQL exporter for Prometheus

# Install PostgreSQL exporter
wget https://github.com/prometheus-community/postgres_exporter/releases/download/v0.8.0/postgres_exporter-0.8.0.linux-amd64.tar.gz
tar -xvf postgres_exporter-0.8.0.linux-amd64.tar.gz
mv postgres_exporter-0.8.0.linux-amd64 /usr/local/postgres_exporter

# Copy configuration file
cp config/postgres_exporter.yml /usr/local/postgres_exporter/postgres_exporter.yml

# Start PostgreSQL exporter
/usr/local/postgres_exporter/postgres_exporter --config.file=/usr/local/postgres_exporter/postgres_exporter.yml &
```

### 4. Set Up Grafana

Use the `setup_grafana.sh` script to set up Grafana.

#### Script: `setup_grafana.sh`

```bash
#!/bin/bash

# setup_grafana.sh
# This script sets up Grafana for visualizing PostgreSQL metrics

# Install Grafana
wget https://dl.grafana.com/oss/release/grafana-7.5.1.linux-amd64.tar.gz
tar -zxvf grafana-7.5.1.linux-amd64.tar.gz
mv grafana-7.5.1 /usr/local/grafana

# Start Grafana
/usr/local/grafana/bin/grafana-server web &
```

### 5. Import Grafana Dashboard

Import the `postgres_dashboard.json` file into Grafana to visualize PostgreSQL metrics.

#### Dashboard File: `postgres_dashboard.json`

This file contains the JSON configuration for a Grafana dashboard that visualizes key PostgreSQL metrics.

### 6. Set Up Alerting Rules

Use the `alert_rules.yml` file to set up Prometheus alerting rules.

#### Alerting Rules: `alert_rules.yml`

```yaml
# alert_rules.yml
# Prometheus alerting rules for PostgreSQL

groups:
  - name: postgres_alerts
    rules:
      - alert: InstanceDown
        expr: up == 0
        for: 1m
        labels:
          severity: critical
        annotations:
          summary: "Instance {{ $labels.instance }} down"
          description: "{{ $labels.instance }} of job {{ $labels.job }} has been down for more than 1 minute."
      - alert: HighCPUUsage
        expr: node_cpu_seconds_total{mode="idle"} < 20
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High CPU usage on {{ $labels.instance }}"
          description: "CPU usage on {{ $labels.instance }} is above 80% for more than 5 minutes."
```

### 7. Documentation

#### Setup Guide

`docs/setup_guide.md`

```markdown
# Setup Guide

## Overview

This guide provides step-by-step instructions for setting up the monitoring system for PostgreSQL using Prometheus and Grafana.

## Steps

1. Set up Prometheus using `setup_prometheus.sh`.
2. Set up the PostgreSQL exporter using `setup_postgres_exporter.sh`.
3. Set up Grafana using `setup_grafana.sh`.
4. Import the Grafana dashboard using `postgres_dashboard.json`.
5. Configure alerting rules using `alert_rules.yml`.
```

#### Dashboard Guide

`docs/dashboard_guide.md`

```markdown
# Dashboard Guide

## Overview

This guide provides instructions for importing and using the Grafana dashboard to monitor PostgreSQL metrics.

## Steps

1. Open Grafana in your browser.
2. Go to the "Dashboards" section.
3. Click "Import" and upload the `postgres_dashboard.json` file.
4. Customize the dashboard as needed.
```

#### Alerting Guide

`docs/alerting_guide.md`

```markdown
# Alerting Guide

## Overview

This guide provides instructions for setting up Prometheus alerting rules for PostgreSQL.

## Steps

1. Copy the `alert_rules.yml` file to the Prometheus configuration directory.
2. Restart Prometheus to apply the new alerting rules.
3. Verify that alerts are working by checking the Prometheus alerting page.
```

### Conclusion

By following these steps, you can set up a comprehensive monitoring system for your PostgreSQL database using Prometheus and Grafana. The provided scripts, configuration files, and dashboards will help you monitor database performance and set up proactive alerting.

## Contributing

We welcome contributions to improve this project. If you would like to contribute, please follow these steps:

1. Fork the repository.
2. Create a new branch.
3. Make your changes.
4. Submit a pull request.

## License

This project is licensed under the MIT License. See the `LICENSE` file for more details.


---

Thank you for using the Database Monitoring with Prometheus and Grafana project! We hope this guide helps you implement a robust monitoring solution for your PostgreSQL databases.
