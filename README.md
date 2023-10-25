# Summary 
In this repository, I've set up a Kubernetes cluster on AWS with Terraform. There's also a Python app where the frontend talks to a backend using Flask, all managed through Nginx. I've used GitHub Actions for deploying the app and checking the code's quality. Plus, with ArgoCD, I've streamlined the app's deployment and added monitoring using Prometheus and Grafana.


# Table of Contents

1. [Kubernetes Kubeadm Cluster on AWS using Terraform](#kubernetes-kubeadm-cluster-on-aws-using-terraform)
    - [Overview](#overview)
    - [Key Features](#key-features)
    - [How to Use](#how-to-use)
2. [Python App with Frontend and MongoDB Backend](#python-app-with-frontend-and-mongodb-backend)
    - [Backend](#backend)
    - [Frontend](#frontend)
3. [GitHub Actions](#github-actions)
4. [Continuous Deployment & Monitoring](#continuous-deployment--monitoring)


# Kubernetes Kubeadm Cluster on AWS using Terraform

This repository provides Terraform scripts to provision a Kubernetes kubeadm cluster on AWS EC2 instances. The number of nodes in the cluster can be customized, and they will automatically join the Kubernetes cluster upon creation.

## Overview

The Terraform script performs the following:

1. Provisions a new VPC.
2. Sets up security groups to handle web traffic and the necessary ports for Kubernetes operations.
3. Provisions a public subnet.
4. Provisions an internet gateway and attaches it to the VPC.
5. Creates an IAM role for EC2 instances and attaches a policy allowing EBS volume management.
6. Provisions the Kubernetes master and worker nodes.

### Key Features:

- **Scalability**: Choose how many worker nodes you want in your cluster.
- **Automated Cluster Joining**: Worker nodes automatically join the Kubernetes cluster upon creation.
  
## How to Use

1. Ensure you have Terraform installed and AWS credentials set up.
2. Clone the repository.
3. Update any variables in the Terraform script, such as instance type or count, as per your requirements.
4. Run the following commands:
   ```bash
   terraform init
   terraform apply

# After the script runs successfully, your Kubernetes kubeadm cluster will be up and running on AWS!


# Python App with Frontend and MongoDB Backend

This repository contains a full-fledged application consisting of a frontend that communicates with a Flask backend through an Nginx proxy to handle CORS issues. The backend provides endpoints for testing MongoDB connection, inserting data, and retrieving data.

## Backend

The backend is built using Flask and provides the following routes:

- **GET /**: Basic endpoint to check if the backend is running.
- **GET/POST /data**: Retrieve or insert data into MongoDB.
- **GET /test_mongo_connection**: Tests the connection to MongoDB and returns the status.

The backend communicates with a MongoDB instance and expects the MongoDB service to be reachable at the host `mongo-service` on port `27017`. Ensure you have this service running and accessible to the backend.

The provided Dockerfile sets up a Python environment, installs necessary dependencies from the `requirements.txt` file, and runs the Flask application using Gunicorn.

## Frontend

The frontend is a simple HTML page that allows users to:

- Load data from the backend.
- Insert data into MongoDB through the backend.
- Test the MongoDB connection.

The frontend is served using Nginx, with a custom configuration that proxies API requests to the backend.

# Python App with Frontend and MongoDB Backend

This repository contains an integrated application with a frontend interfacing with a Flask backend, facilitated by an Nginx proxy. This architecture mitigates CORS challenges. The backend offers functionalities like MongoDB connection testing, data storage, and retrieval.

# GitHub Actions

- **GitHub Actions Integration**:
    - **Deployment**: The frontend and backend are automatically deployed to Docker Hub using a dedicated GitHub action.
    - **Code Quality Checks**: We've integrated a SonarCloud GitHub action to ensure rigorous code validation and uphold the highest standards of quality.

## Continuous Deployment & Monitoring

- **ArgoCD**: 
    - **App Deployment**: I utilize ArgoCD to manage the deployment of this application through Helm charts, ensuring seamless and automated rollouts.
    - **Prometheus & Grafana**: Alongside the application, ArgoCD is also responsible for the deployment of Prometheus and Grafana, offering robust monitoring and visualization capabilities for the infrastructure.

