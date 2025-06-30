# node-api-repo# Node.js API Deployment on Google Cloud Run

This project demonstrates a secure CI/CD pipeline for deploying a Node.js API to Google Cloud Run using GitHub Actions. The solution includes vulnerability scanning, Docker best practices, and least-privilege IAM configuration.

[![CI/CD Pipeline](https://github.com/your-username/node-api-repo/actions/workflows/cloudrun-ci-cd.yml/badge.svg)](https://github.com/your-username/node-api-repo/actions)

## Project Overview
- Simple "Hello World" JSON API using Express.js
- Automated CI/CD pipeline with GitHub Actions
- Docker containerization with security
- Deployment to Google Cloud Run (fully managed)
- Vulnerability scanning with Trivy
- Infrastructure as Code using gcloud CLI

**Live Endpoint**:  
https://node-api-service-omxwkythmq-uc.a.run.app/

```json
// Example Response
{
  "status": "ok"
}

