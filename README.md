# **Assignment 3: Auto-Scaling Flask Application on GCP**

Rhythm Patni (B22CS043)                                                       [Repository Link](https://github.com/rhythmp17/VCC_Assignment3) | [Demo Video Link](https://drive.google.com/file/d/12u_JmIhhv4X6bMN5mfezcROer9cF8dmh/view?usp=sharing)  
---

## **1\. Introduction**

This assignment focuses on implementing an automated scaling mechanism for a Flask application based on resource utilization. The objective is to monitor CPU and memory usage on a local Virtual Machine (VM) and trigger the deployment of the application to a Google Cloud Platform (GCP) VM when the resource usage exceeds a defined threshold.

---

## **2\. Implementation Details**

### **2.1 System Overview**

The implementation involves the following steps:

* **Resource Monitoring**: Continuously track CPU and memory utilization on the local VM.  
* **Threshold-Based Scaling**: If CPU or memory usage exceeds 75%, deploy the application to a GCP instance.  
* **Flask Application Deployment**: Start a simple Flask web server on the GCP VM upon scaling.  
* **Traffic Redirection**: Redirect traffic from the local VM to the newly created GCP instance.

### **2.2 Steps to Implement**

The following has to be done locally

1. Install VirtualBox or any VM application  
2. Setup a local VM (We set up ubuntu)  
3. Install htop to monitor system resources  
4. Install flask to host app on local machine.

The following has to be done on GCP 

1. Create a Service Account.  
2. Get JSON key  
3. Grant Compute Admin Role and Service Account User Role

### 

### **2.3 Bash Script Implementation**

This Bash script monitors system resource usage (CPU and memory) and automatically deploys a Flask web application on Google Cloud Platform (GCP) if the usage exceeds predefined thresholds. Here's how it works in detail:

### **1\. Authentication with GCP**

* The script sets up authentication using a service account key.  
* It ensures that the script can interact with GCP services by activating the service account.  
* If authentication fails, the script exits immediately.

### **2\. Monitoring CPU and Memory Usage**

* The script continuously monitors CPU and memory usage on the local machine.  
* It calculates CPU usage by checking idle time and subtracting it from 100%.  
* Memory usage is determined by comparing used memory to total memory.  
* The resource usage is logged for tracking purposes.

### **3\. Triggering Scaling Based on Thresholds**

* If CPU or memory usage exceeds 75%, the script initiates scaling.  
* It logs that resource limits have been exceeded and begins the process of deploying a new instance on GCP.

### **4\. Deploying a Flask App on GCP**

* The script creates a startup script that:  
  * Updates system packages.  
  * Installs Python and Flask.  
  * Writes a simple Flask web application that responds with "Hello from GCP\!".  
  * Starts the Flask app in the background.  
* A new GCP virtual machine (VM) is launched with:  
  * A specified instance name, zone, and machine type.  
  * An Ubuntu 20.04 operating system.  
  * HTTP and HTTPS traffic enabled.

### **5\. Obtaining the GCP Instance's Public IP**

* After deployment, the script waits briefly for the instance to start.  
* It retrieves the external IP address of the instance.  
* It logs and displays the public URL where the Flask app is running.

### **6\. Continuous Monitoring**

* The script runs in an infinite loop, checking resource usage every 10 seconds.

## **3\. Simulating Load on the System and Scaling it.**

### **3.1 Flask APP on VM**

On a local VM, this dummy application is just a python file which starts a server returning some text.This server runs on localhost on port 5000\. It has a route ‘/load’, on hitting this route, the server goes into an infinite loop and CPU utilization shoots up to 100%, which can be detected by the monitor.sh script.

### **3.2 Flask App on Public Cloud VM**

As soon as the VM is created, it runs the startup script which install the dependencies of flask app on GCP VM and starts the Flask server on the VM on port 80, which can be accessed from any browser using External IP of the GCP VM.

### **3.3 Architecture Diagram**

![Screenshot 2025-03-23 131302](https://github.com/user-attachments/assets/0ffcbf5c-6087-4d1d-8ea6-05d18b2937de)

 

## **4\. Results & Observations**

* The script successfully monitored CPU and memory usage.  
* Upon exceeding the threshold, the Flask application was deployed to GCP.  
* The new instance was accessible via the displayed external IP address.  
* Traffic redirection was handled dynamically.

---

