# Murpet Project

[![Build Status](https://dev.azure.com/NunsiShiaki/Murpet-Project/_apis/build/status/Murpet-Project?branchName=main)](https://dev.azure.com/NunsiShiaki/Murpet-Project/_build/latest?definitionId=1&branchName=main)

## Overview
The Murpet Project is a modern Node.js/Express web application hosted on Azure. It demonstrates a high-maturity DevOps lifecycle using **Infrastructure as Code (Terraform)**, **Multi-Stage Pipelines (Azure DevOps)**, and **Zero-Downtime Deployments**.

## 🏗 Architecture
The infrastructure is provisioned entirely via Terraform and includes:
* **App Service (Linux):** Hosting the Node.js 18 application.
* **Deployment Slots:** Production utilizes a "Staging Slot" for zero-downtime swaps.
* **Application Insights:** Full observability and performance monitoring.
* **Log Analytics Workspace:** Centralized log retention.

### Environments & Scaling
The infrastructure dynamically scales based on the environment tier:

| Environment | Branch | SKU | Description |
| :--- | :--- | :--- | :--- |
| **Development** | `dev` | **B1** (Basic) | Cost-effective tier for feature testing. |
| **Staging** | `staging` | **B1** (Basic) | Mirror of production for final QA. |
| **Production** | `main` | **P1v2** (Premium) | High-performance tier with auto-scale capabilities. |

---

## 🚀 DevOps Strategy

### Branching Model (Gitflow-lite)
1.  **Feature Branches:** Developers work on `feature/*`.
2.  **Dev Branch:** PRs are merged to `dev` for integration testing. **(Auto-deploys to Dev Env)**
3.  **Staging Branch:** Code is promoted to `staging`. **(Auto-deploys to Staging Env)**
4.  **Main Branch:** Code is promoted to `main`. **(Deploys to Prod Slot -> Manual Swap)**

### CI/CD Pipeline
The `azure-pipelines.yml` defines the workflow:
1.  **Build:** Runs `npm install`, tests, and packages the artifact.
2.  **Terraform:** Calculates the plan and applies infrastructure changes (Idempotent).
3.  **Deploy:** Pushes the artifact to the specific Azure Web App.

---

## 🛡 Security & Governance
* **State Management:** Terraform state is stored remotely in Azure Blob Storage with locking enabled.
* **Code Owners:** The `/infra` directory is protected via `CODEOWNERS`. Only authorized DevOps engineers can approve infrastructure changes.
* **Secrets:** No secrets are stored in code. All credentials use Azure Service Connections.

## 🛠 Local Development
To run the app locally:

1.  Clone the repository.
2.  Install dependencies:
    ```bash
    cd src
    npm install
    ```
3.  Start the server:
    ```bash
    node server.js
    ```
4.  Visit `http://localhost:3000`.

## ☁️ Infrastructure Deployment
(For authorized DevOps personnel only)

The infrastructure is managed automatically by the pipeline. To modify it:
1.  Edit files in `infra/`.
2.  Update `infra/variables.tf` if adding new inputs.
3.  Commit changes to a feature branch and merge to `dev`.