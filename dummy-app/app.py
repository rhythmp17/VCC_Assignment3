from flask import Flask
import multiprocessing
import time

app = Flask(__name__)

@app.route("/")
def home():
    return "Hello, this is the local VM running the Dummy App!"

@app.route("/load")
def load():
    """Endpoint to simulate high CPU usage"""
    def cpu_intensive():
        while True:
            pass  # Infinite loop to generate CPU load

    # Launch multiple processes to increase CPU usage
    for _ in range(multiprocessing.cpu_count()):
        p = multiprocessing.Process(target=cpu_intensive)
        p.start()
    
    return "CPU Load Test Started!"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)

