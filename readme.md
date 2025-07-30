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

## 🛠️ What Can Fail During Script Execution?

When automating deployment with shell scripts, several failure points can occur:

- **Git Clone Failures**  
  If SSH keys or GitHub access tokens are not configured properly, the `git clone` step will fail.

- **Missing JAR File**  
  The script assumes the `.jar` file is available at a specific path (e.g., `build/libs/project.jar`). If the project isn't built beforehand, this causes failure.

- **Java App Launch Failure**  
  If the app crashes due to misconfigured ports, missing environment variables, or internal exceptions, the `java -jar` command will fail.

- **Docker Errors**  
  Docker image build might fail due to an invalid `Dockerfile`. Running the container may also fail if the required port is already in use or the network is misconfigured.

- **SSH or Permission Issues**  
  When deploying to an EC2 instance, if the SSH key is invalid, the username is incorrect, or the IP is wrong, deployment will fail.

- **Port Availability**  
  Port `9000` must be free. If it's already in use, the Java app or Docker container won't start.

---

## 📜 Logging by Scripts

Logging is used throughout to make debugging easy:

- **Shell Script Logs**  
  Each step logs output via `echo`, showing messages like _“JAR file not found”_ or _“Docker build successful”_.

- **Java Logs**  
  Output from the Java app is redirected to a file (e.g., `app.log`). This includes server start info and runtime errors.

- **GitHub Actions Logs**  
  GitHub Actions logs every job and step by default. Any failed step is marked with ❌ and clickable to debug.


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

## ⚙️ Parameters in Load Balancer (AWS ELB)

In AWS, these are the key configurations for the Load Balancer used in this setup:

- **Type**: Application Load Balancer (ALB) with IPv4, internet-facing.
- **Target Group**: Points to the EC2 instance where the app is deployed, with `target-type` as `instance` and port `9000`.
- **Listener**: Listens on HTTP port `80` and forwards requests to the registered target group.
- **Simplified Setup**: This setup avoids SSL configuration, HTTPS listener, advanced routing rules, sticky sessions, and auto-scaling — to keep the scope focused and reduce complexity.

---

## 👨‍💻 Author

**Amit Ranjan**  
Email: amit.ranjan1@allen.in  
GitHub: [@amitranjan9708](https://github.com/amitranjan9708)

---

## 🛡️ License

This project is licensed under MIT License.



