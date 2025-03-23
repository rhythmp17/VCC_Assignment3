#!/bin/bash

# Service Account Key File
SERVICE_ACCOUNT_KEY="vcc-assignment2-452416-dfc64ca7e2d5.json"

# Thresholds
CPU_THRESHOLD=75
MEM_THRESHOLD=75

# GCP Configuration
GCP_INSTANCE_NAME="ubuntu-flask-instance"
GCP_ZONE="us-central1-a"
GCP_MACHINE_TYPE="e2-medium"

# Authenticate GCP
authenticate_gcp() {
    export GOOGLE_APPLICATION_CREDENTIALS=$SERVICE_ACCOUNT_KEY
    gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS

    if [ $? -eq 0 ]; then
        echo "$(date) - Authentication successful!"
    else
        echo "$(date) - Authentication failed. Exiting..."
        exit 1
    fi
}

# Check CPU & Memory Usage
check_resources() {
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
    MEM_USAGE=$(free | awk '/Mem/ {printf("%.0f"), $3/$2 * 100}')

    echo "$(date) - CPU Usage: $CPU_USAGE% | Memory Usage: $MEM_USAGE%"

    if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )) || (( $(echo "$MEM_USAGE > $MEM_THRESHOLD" | bc -l) )); then
        echo "$(date) - Resource limit exceeded. Scaling application to GCP..."
        scale_gcp
    fi
}

# Launch GCP VM & Deploy Flask App
scale_gcp() {
    echo "$(date) - Deploying Flask App on GCP..."

    # Write the startup script to a file
    cat <<EOF > startup-script.sh
#! /bin/bash
sudo apt update -y
sudo apt install -y python3 python3-pip
pip3 install flask

cat <<APP_EOF > /home/ubuntu/app.py
from flask import Flask
app = Flask(__name__)

@app.route('/')
def home():
    return 'Hello from GCP!'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
APP_EOF

cd /home/ubuntu
nohup python3 app.py > flask.log 2>&1 &
EOF

    # Create the GCP instance with HTTP and HTTPS enabled
    gcloud compute instances create $GCP_INSTANCE_NAME \
        --zone=$GCP_ZONE \
        --machine-type=$GCP_MACHINE_TYPE \
        --image-family=ubuntu-2004-lts \
        --image-project=ubuntu-os-cloud \
        --metadata-from-file startup-script=startup-script.sh \
        --tags=http-server,https-server  # Enable HTTP and HTTPS traffic

    echo "$(date) - Waiting for instance to start..."
    sleep 10  

    # Get External IP
    GCP_IP=$(gcloud compute instances list --filter="name=('$GCP_INSTANCE_NAME')" --format="value(networkInterfaces[0].accessConfigs[0].natIP)")

    if [ -z "$GCP_IP" ]; then
        echo "$(date) - Error: Could not fetch external IP of the GCP instance."
        exit 1
    fi

    echo "$(date) - GCP Flask App Deployed!"
    echo "$(date) - GCP Instance Running at http://$GCP_IP"
}

# Start Monitoring
authenticate_gcp
while true; do
    check_resources
    sleep 10  # Check every 10 seconds
done


