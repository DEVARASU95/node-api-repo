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

// Example Response
{
"status": "ok"
}

# CI/CD Setup Instructions for Node.js App on Google Cloud Run

## 1️⃣ Prerequisites 

Ensure the following are installed and configured:

- ✅ Google Cloud Platform (GCP) account  
- ✅ GitHub account  
- ✅ [Node.js v20+](https://nodejs.org/)  
- ✅ [Docker](https://www.docker.com/products/docker-desktop) (optional, for local builds)  
- ✅ [Google Cloud CLI (gcloud)](https://cloud.google.com/sdk/docs/install)  

---

# Setup Instructions

## 1. Prerequisites

- Google Cloud account  
- GitHub account  
- Node.js v20+

## 2. GCP Project Setup

```bash
gcloud projects create YOUR_PROJECT_ID
gcloud config set project YOUR_PROJECT_ID
gcloud services enable run.googleapis.com artifactregistry.googleapis.com

## 3. Service Account Configuration

```bash
SA_EMAIL="github-actions-sa@YOUR_PROJECT_ID.iam.gserviceaccount.com"

# Create service account
gcloud iam service-accounts create github-actions-sa \
  --display-name="GitHub Actions SA"

# Assign least-privilege roles
gcloud projects add-iam-policy-binding YOUR_PROJECT_ID \
  --member="serviceAccount:$SA_EMAIL" \
  --role="roles/run.developer"

gcloud projects add-iam-policy-binding YOUR_PROJECT_ID \
  --member="serviceAccount:$SA_EMAIL" \
  --role="roles/artifactregistry.writer"

gcloud projects add-iam-policy-binding YOUR_PROJECT_ID \
  --member="serviceAccount:$SA_EMAIL" \
  --role="roles/iam.serviceAccountUser"

## 4. GitHub Secrets

Add to **Repository Settings → Secrets → Actions**:

- `GCP_PROJECT_ID`: Your GCP project ID  
- `GCP_SA_KEY`: Service account key JSON  

### IAM Roles (Least-Privilege)

| Role                         | Purpose                    | Scope            |
|------------------------------|----------------------------|------------------|
| `roles/run.developer`        | Deploy/update services     | Project          |
| `roles/artifactregistry.writer` | Push/pull container images | Repository        |
| `roles/iam.serviceAccountUser` | Impersonate service accounts | Service Account  |

### Why not admin roles?

- `run.admin` allows service deletion (**overprivileged**)  
- `artifactregistry.admin` allows repository management (**unnecessary**)  
- **Least-privilege reduces risk if credentials are compromised**

## 💰 Cost Estimate

All resources are within the **GCP Free Tier**:

| Service           | Free Tier         | Usage        | Cost   |
|-------------------|-------------------|--------------|--------|
| Cloud Run         | 2M req/month      | 500 req/day  | $0.00  |
| Artifact Registry | 0.5GB storage     | 150MB        | $0.00  |
| Network Egress    | 1GB/month         | 100MB        | $0.00  |

**Total Cost: $0.00**

## 5. Vulnerability Management

- Trivy scanning in CI pipeline  
- Critical/high severity issues block deployment  
- Automatic updates via Dependabot  
- Pinned dependencies in `package.json`  

## 6. Cost Optimization

- Cloud Run **scale-to-zero** to avoid idle costs  
- Use **regional Artifact Registry** to minimize network egress  
- Maximize usage of **Free-tier resource allocation**  

## 🔁 Rollback Procedure

```bash
# Rollback to previous version
gcloud run deploy node-api-service \
  --image=us-central1-docker.pkg.dev/PROJECT_ID/REPO/IMAGE@sha256:PREVIOUS_SHA \
  --region us-central1
