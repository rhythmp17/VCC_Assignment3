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
