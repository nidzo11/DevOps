# Python App Deployment on Kubernetes with Helm

## 🚀 Overview

### Kubernetes Cluster Deployment with Terraform:
- **Description**: Developed a Terraform script for one-command deployment.
- **Infrastructure**: Utilizes three EC2 instances on AWS to form the Kubernetes cluster.

### Application Setup:
- **Frontend**: 
  - **Platform**: NGINX server.
  - **Accessibility**: Exposed through a NodePort.
- **Backend**: 
  - **Database Connection**: Interacts with MongoDB.

### Deployment Methodology:
- **Tool**: Helm.
- **Purpose**: Provides structured and simplified deployment of the entire application on the Kubernetes cluster.

### CI/CD with GitHub Actions:
- **Automation**: 
  - Docker image creation for frontend and backend.
  - Pushing updates to Docker Hub.

### Code Quality Assurance:
- **Tool**: SonarQube.
- **Function**: Enables continuous code quality checks and validation.

## 📦 Components

### 🖥️ Frontend

- **Description**:
  - User interface for the Python App.
  - Interaction with the backend using API calls.
  
- **Deployment**:
  - **Container**: Based on `nginx:alpine` Docker image.
  - **Endpoints**:
    - **Load Data**: Fetches data.
    - **Submit Data**: Sends new data.
    - **Test MongoDB Connection**: Validates connection.

### 🛠️ Backend

- **Description**:
  - Flask API interfacing with MongoDB.
  
- **Deployment**:
  - **Container**: Operates on `python:3.9` Docker image.
  - **Command**: `gunicorn app:app --bind 0.0.0.0:5000`.
  
- **Endpoints**:
  - **GET /**: Status check.
  - **GET, POST /data**: Data operations.
  - **GET /test_mongo_connection**: Connection test.

### 🗄️ MongoDB

- **Description**: 
  - Database for the app.
  
- **Deployment**:
  - **Container**: Official `mongo` Docker image (tag: 4.4).

## ⚙️ Helm Chart and Kubernetes Details

The application is encapsulated as a Helm chart. Adjust configurations in Helm's `values.yaml`.

## 📋 Deployment Guide

1. Use Helm for deployment:
   ```bash
   helm install <release_name> ./<chart_name>

# Kubernetes Cluster Deployment in AWS using Terraform

## 🚀 Infrastructure Overview

- **AWS Provider**
- **VPC**
- **Security Groups**
- **Subnet**
- **Internet Gateway**
- **Route Table**
- **IAM Role and Policies**
- **EC2 Instances**

## 📜 Scripts

- **Master Node**: `master.sh`
- **Worker Node**: `worker.sh`

## 📋 Usage

1. Install Terraform.
2. Clone this repo.
3. Initiate Terraform with `terraform init`.
4. Deploy with `terraform apply`.

> **Note**: Ensure variable setup before executing Terraform code.

## 🤖 GitHub Actions

### 📦 Push Docker Image

Activated on specific `main` branch pushes. Actions include:
- Code checkout.
- Backend and frontend Docker image operations.

### 🔍 SonarCloud Analysis

Triggered for `main` branch pushes and pull requests. Actions:
- Repository checkout.
- SonarCloud code analysis.   