# 🚀 DevOps Java App Deployment Project

This project automates the deployment of a Java application using GitHub Actions, Docker, and AWS services including EC2 and Elastic Load Balancer (ELB).

---

## 📌 Project Overview

The pipeline:
1. Clones a Java application from a GitHub repository.
2. Runs the JAR locally (or containerized).
3. Dockerizes the app.
4. Pushes the Docker image to DockerHub.
5. Deploys it on an AWS EC2 instance via SSH.
6. Configures an Elastic Load Balancer for public access.

---

## ✅ Assumptions

- 🔐 SSH access to GitHub is pre-configured with a valid key.
- 📦 Built JAR available at: `build/libs/project.jar`.
- 🛠️ EC2 has `Docker`, `Git`, and `Java` installed.
- 🚪 The server runs on **port 9000** after executing the JAR.
- 🔑 IAM role/user exists with permissions for EC2 and ELB management.

---

## 📜 Scripts Overview

### 1. `run_app.sh`
- Clones the repository using SSH.
- Verifies the presence of the JAR file.
- Runs the app via `java -jar` and logs output to `app.log` using `nohup`.

### 2. `Dockerfile`
- Base: `openjdk:17-jdk-slim`.
- Copies JAR into the container.
- Exposes port `9000`.
- Runs the JAR using `CMD`.

### 3. `.github/workflows/deploy.yml` (CI/CD Pipeline)
- Triggers on push to `main` branch.
- Builds Docker image and pushes to DockerHub.
- SSHes into EC2 and deploys container.

### 4. `create_elb.sh`
- Creates:
  - Target group.
  - Application Load Balancer.
- Configures listener on port `80` → forwards to EC2 on `9000`.
- Registers the EC2 instance to target group.

---

## ⚠️ Failure Handling & Logging

- SSH clone failures are handled with key and URL checks.
- Ensures JAR file exists before execution.
- Logs all Java output to `app.log` using `nohup`.
- GitHub Actions fail-fast with logs available in Actions UI.
- Docker deploy steps include fallback for container restarts.

---

## 🌐 Load Balancer Configuration

| Setting         | Value             |
|-----------------|-------------------|
| **Port**        | 9000 (App)        |
| **Type**        | Application       |
| **Scheme**      | Internet-facing   |
| **Target Type** | Instance          |

> ⚠️ Not Configured:
> - Health checks
> - HTTPS (Only HTTP listener for simplicity)

---

---

## 👨‍💻 Author

**Amit Ranjan**  
Email: amit.ranjan1@allen.in  
GitHub: [@amitranjan9708](https://github.com/amitranjan9708)

---

## 🛡️ License

This project is licensed under MIT License.



