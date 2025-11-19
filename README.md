# 🚀 eloquent\_api

A scalable and modern API service, designed for cloud-native deployment using **AWS Fargate** and managed with **Terraform**. This repository contains the application source code, Docker configuration, and the complete infrastructure-as-code (IaC) necessary for deployment.

## ✨ Features

  * **RESTful API:** (Inferred) The core application provides robust API endpoints.
  * **Containerized:** Built with Docker for consistent, portable environments.
  * **Infrastructure as Code (IaC):** AWS infrastructure is defined and managed using **Terraform**.
  * **Cloud-Native Deployment:** Deploys to AWS using **ECS (Elastic Container Service) with Fargate**, managed by an **Application Load Balancer (ALB)**.
  * **CI/CD Automation:** Includes automated workflows using **GitHub Actions** for continuous integration and deployment.

-----

## 📂 Repository Structure

| Directory/File | Description |
| :--- | :--- |
| `app/` | Contains the main Python source code for the API application. |
| `terraform/` | Contains the complete infrastructure-as-code (IaC) for AWS using Terraform. |
| `.github/workflows/` | Configuration files for **GitHub Actions** to automate CI/CD processes. |
| `Dockerfile` | Defines the environment and commands to build the containerized API application. |
| `README.md` | This file. |

## 🏛️ Architecture Overview

The infrastructure employs a secure and highly available **three-tier architecture** within an **AWS Virtual Private Cloud (VPC)**.

  * **Compute:** **AWS Fargate** runs the API container, abstracting server management.
  * **Ingress:** An **Application Load Balancer (ALB)** handles public traffic, SSL termination, and distributes requests.
  * **Security:** AWS Fargate in **Private Subnets**, isolated from the public internet.

## ⚙️ Prerequisites

To deploy and run this project, you will need the following tools installed and configured:

1.  **Git**
2.  **Docker** (for local development)
3.  **Make** (for running Makefile targets) 
4.  **Terraform CLI** (v1.0+) (for infrastructure management)
5.  **AWS CLI** (configured with appropriate credentials)
6.  **Python** (for application code inspection/development)
7.  **S3 State Bucket** (to store state files for terraform)

## ☁️ AWS Deployment (Terraform)

The infrastructure is defined entirely within the `terraform/` directory. The terraform structure is divided in the following sections:

### Modules

Inside this folder, all the terraform reusable code is stored. All the definitions used by the other folders, lives here.

### Shared

The shared folder is the instanciation of modules that can be global and reusable across multiple accounts. In there we have:

- ECR

### Core

The core folder represents the instanciation of the core module. The core module is the one that defines all the network and runtime resources. In there we have:

- VPC
- ECS Cluster
- Service Discovery
- VPC endpoints

### App

The app folder is the instanciation of the app module. The app module defines all the resources that are related with the application lifecycle. In there we have:

- ECS Service
- ECS Task definition
- ALB
- Cloudwatch Alarms



### 1\. Initialize Terraform

Navigate to the Terraform folder and enter in one of the 3 previous folder. Once in, initialize the backend and providers using make.

```bash
cd terraform/<app/core/shared>
make init ENV=<environment_name>
```

### 2\. Review the Plan

Generate an execution plan to see what resources Terraform will create.

```bash
make plan ENV=<environment_name>
```

### 3\. Apply the Configuration

Apply the configuration to provision the AWS infrastructure.

```bash
make apply ENV=<environment_name>
```

This process will provision all necessary AWS resources, defined on that folder.

### Step ⚠️: Destroying the Infrastructure

To completely remove all deployed AWS resources defined on that folder (use with extreme caution):

```bash
make destroy ENV=<environment_name>
```

## ⚙️ CI/CD Pipeline: Layered Terraform Deployment

This document explains the architecture and execution flow of the highly structured, manually triggered GitHub Actions workflow. This pipeline is designed to deploy AWS infrastructure in a safe, layered, and sequential manner using **Terraform** and **OpenID Connect (OIDC)** for secure AWS authentication.

---

### 1. 🎯 Pipeline Overview and Trigger

This pipeline is engineered for controlled deployment of complex infrastructure, dividing resources into three independent, yet sequentially dependent, layers: `shared`, `core`, and `app`.

#### Trigger Mechanism

The workflow uses a single, controlled trigger:

* **Manual Dispatch (`workflow_dispatch`):** The pipeline must be started manually from the GitHub Actions tab.
    * **Input:** It requires the user to select the `environment` (ecurrently restricted to `dev`) to deploy, ensuring targeted execution.

#### Concurrency

The `concurrency` block ensures deployment safety:

* **Group:** `group: ${{ inputs.environment }}` means that only one workflow run can be active for a given target environment (e.g., `dev`) at any time.
* **Safety:** `cancel-in-progress: false` ensures that a running deployment is never automatically cancelled by a newer run, prioritizing stability over speed.

---

### 2. 🔒 Security and Authentication (OIDC)

The pipeline employs a modern, keyless authentication method to access AWS:

* **IAM Role:** The `role_arn` specified in each job points to an AWS IAM Role (`arn:aws:iam::951296734763:role/github-actions-role`).
* **OIDC:** The `permissions: id-token: write` setting enables the workflow to generate an OIDC token that AWS validates. This token allows the GitHub Runner to assume the designated IAM Role **without storing any long-lived AWS secrets** (like `AWS_ACCESS_KEY_ID` or `AWS_SECRET_ACCESS_KEY`) in the repository secrets.

---

### 3. 🏗️ Layered Deployment Flow

The core feature of this pipeline is its strict, six-step sequential execution, ensuring that foundational resources are provisioned before application-specific ones. This prevents dependency failures and isolates changes.



#### A. Shared Infrastructure Layer (`./terraform/shared`)

This layer provisions fundamental, cross-cutting resources, such as the **ECR repositories** and **IAM roles** required by other layers.

| Job Name | Dependency | Purpose |
| :--- | :--- | :--- |
| `shared_terraform_plan` | None | Runs **Plan** against the `./terraform/shared` directory. |
| `shared_terraform_apply` | `shared_terraform_plan` | Runs **Apply**, provisioning the shared resources. |

#### B. Core Infrastructure Layer (`./terraform/core`)

This layer provisions the primary networking and foundational compute services, which depend on the Shared layer's output (e.g., the remote state). This typically includes the **VPC**, **Subnets**, **ECS Cluster**, and **security groups**.

| Job Name | Dependency | Purpose |
| :--- | :--- | :--- |
| `core_terraform_plan` | `shared_terraform_apply` | Runs **Plan** against the `./terraform/core` directory. |
| `core_terraform_apply` | `core_terraform_plan` | Runs **Apply**, provisioning the networking and compute foundation. |

#### C. Application Layer (`./terraform/app`)

This layer provisions the application-specific resources that live within the Core framework. This typically includes the **Application Load Balancer (ALB)**, **ECS Service**, **Task Definitions**.

| Job Name | Dependency | Purpose |
| :--- | :--- | :--- |
| `app_terraform_plan` | `core_terraform_apply` | Runs **Plan** against the `./terraform/app` directory. |
| `app_terraform_apply` | `app_terraform_plan` | Runs **Apply**, deploying the application environment. |

### 4. 🛠️ Custom Actions

The pipeline uses two custom actions (located in `.github/actions/`) to simplify the steps and reuse logic across the six jobs:

1.  **`./github/actions/terraform_plan`:**
    * Handles checkout, Terraform setup, `init`, `validate`, and `plan`.
    * Manages the assumption of the AWS IAM Role using OIDC.
2.  **`./github/actions/terraform_apply`:**
    * Handles checkout, `init`, and execution of the plan artifact via `terraform apply -auto-approve`.
    * Manages the assumption of the AWS IAM Role.

This modular structure ensures that the complex multi-stage deployment is clean, reliable, and easily maintainable.

## ⚙️ CI/CD Pipeline Documentation: Eloquent APP

This document details the **Eloquent APP** GitHub Actions pipeline, which is responsible for the full Continuous Integration (CI) and Continuous Deployment (CD) lifecycle of the Python application code. The pipeline ensures code quality, security, and automated deployment to **AWS Elastic Container Service (ECS)** using **OpenID Connect (OIDC)** for secure authentication.

---

### 1. 🎯 Pipeline Overview and Triggers

This workflow is focused on taking application source code from the `./app` directory, validating it, turning it into a container image, and deploying it to a target AWS ECS environment.

#### Triggers

The pipeline is primarily executed by development activities:

* **Push to `main`:** The entire CI/CD process (linting, security, build, and deploy) runs automatically whenever code is merged or pushed directly to the `main` branch.
* **Manual Dispatch (`workflow_dispatch`):** Allows the pipeline to be manually triggered from the GitHub Actions tab, useful for re-runs or specific deployment scenarios.

#### Security (OIDC)

The pipeline uses **OpenID Connect (OIDC)** for keyless authentication with AWS.

* `permissions: id-token: write` enables the GitHub runner to generate a short-lived token.
* This token is used by the `aws-actions/configure-aws-credentials` step to assume the target IAM Role (`arn:aws:iam::951296734763:role/github-actions-role`), granting temporary deployment access without storing permanent keys in GitHub Secrets.

---

### 2. 🧪 Job 1: `lint` (Code Quality)

This is the first gate in the pipeline, ensuring that the code adheres to established quality standards before proceeding.

| Step | Command/Tool | Purpose |
| :--- | :--- | :--- |
| **Setup** | `actions/checkout`, `pip install pipenv` | Checks out the code and installs `pipenv` to manage Python dependencies. |
| **Code Lint** | `make lint` | Executes linting tools (e.g., Flake8, Black) on the Python code in `./app` to check for style issues and potential bugs. |
| **Dockerfile Lint** | `make docker-lint` | Runs linting tools specifically against the `./app/Dockerfile` to ensure it follows best practices. |

---

### 3. 🛡️ Job 2: `security_checks` (Vulnerability Scanning)

This job runs security checks against both the source code and the resulting container image.

| Step | Command/Tool | Purpose |
| :--- | :--- | :--- |
| **Code Security** | `make security` | Executes static analysis security tools (e.g., Bandit) on the Python code to identify common vulnerabilities. |
| **Image Build** | `docker build` | Builds a temporary Docker image, tagged with the commit SHA (`eloquent:${{ github.sha }}`). |
| **Trivy Scan** | `aquasecurity/trivy-action` | Scans the newly built Docker image for known vulnerabilities in the OS and libraries. **Crucially, it is configured to fail the pipeline if CRITICAL or HIGH severity issues are found.** |


---

### 4. 📦 Job 3: `build_and_push` (Containerization)

This job prepares the validated and secured application for deployment by building the final production image and pushing it to the private AWS registry.

| Step | Action/Service | Purpose |
| :--- | :--- | :--- |
| **AWS Auth** | `aws-actions/configure-aws-credentials` | Assumes the `github-actions-role` using OIDC. |
| **ECR Login** | `aws-actions/amazon-ecr-login` | Authenticates the Docker client with the **Amazon ECR** registry. |
| **Build & Push** | `docker build`, `docker push` | Builds the production image, tags it with the commit SHA, and pushes it to the target ECR repository (`eloquent/eloquent-app`). |

---

### 5. 🚀 Job 4: `deploy_service_to_dev` (Continuous Deployment)

This final job handles the actual deployment to the target **AWS ECS Fargate** environment.

| Step | Action/Service | Purpose |
| :--- | :--- | :--- |
| **AWS Auth & ECR Login** | `aws-actions/configure-aws-credentials`, `aws-actions/amazon-ecr-login` | Re-authenticates and logs into ECR, necessary for accessing deployment parameters. |
| **Download Task Definition** | `aws ecs describe-task-definition` | Downloads the *current* active Task Definition JSON from ECS. |
| **Update Task Definition** | `sed` commands, `aws-actions/amazon-ecs-render-task-definition` | **Crucial Deployment Logic:** Updates the downloaded Task Definition file: 1. Replaces the hardcoded `APP_VERSION` environment variable to match the current `github.sha`. 2. Renders the new ECR image URI (from Job 3) into the `dev-eloquent-app` container definition. |
| **Deploy Service** | `aws-actions/amazon-ecs-deploy-task-definition` | Instructs the ECS cluster (`dev-eloquent-cluster`) to update the service (`dev-eloquent-app`) with the newly generated Task Definition, initiating a rolling update of the containers. |


## 💻 Local Development

The application is written in Python and is set up to run inside a Docker container.

### 1\. Build the Docker Image

Build the application's Docker image using the `Dockerfile` (inferred) and name it appropriately.

```bash
docker build -t eloquent-api:latest .
```

### 2\. Run the Container

Run the newly built container, mapping a local port (e.g., `8000`) to the container's exposed port.

```bash
docker run -p 8080:8080 eloquent-api:latest
```

The API should now be accessible at `http://localhost:8080`.

## 🔒 Security Considerations

### Implemented Measures

  * **VPC Isolation:** Core services (**Fargate**) are deployed in **Private Subnets**.
  * **Security Groups:** Traffic is strictly filtered, allowing only required internal communication (e.g., ALB to Application).
  * **IAM Roles:** Dedicated, least-privilege **Task Roles** are assigned to the Fargate containers.
  * **VPC Flow Logs:** Is enabled capturing all network traffic data for security auditing and troubleshooting.
  * **Support of TLS on ALB:** The ALB supports adding a certificate to only allow HTTPS connections between client and service.

### Recommended Production Enhancements

  * **Secrets Management:** Integrate **AWS Secrets Manager** to store and retrieve database credentials and sensitive environment variables securely.
  * **WAF Protection:** Deploy **AWS WAF** in front of the **ALB** to mitigate common web application attacks (e.g., SQL injection, XSS).
