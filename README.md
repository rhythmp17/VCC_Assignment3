# **Assignment 3: Auto-Scaling Flask Application on GCP**

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

### **2.2 Bash Script Implementation**

A Bash script (`monitor.sh`) automates the process, performing the following tasks:

1. **Authenticate with GCP** using a service account.  
2. **Monitor system resources** using the `top` and `free` commands.  
3. **Trigger scaling** when resource usage crosses the defined threshold.  
4. **Deploy a Flask application** on a newly created GCP instance.  
5. **Fetch the external IP address** of the instance and display the new URL.

## 

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

