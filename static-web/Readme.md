# CI/CD Workflow with GitHub Actions for Docker Image Deployment

## This project sets up an automated CI/CD pipeline using **GitHub Actions** to build and push a Docker image to Docker Hub and send success or failure notifications to **Slack**. This README documents the entire process including encountered issues and resolutions.

## Project Tasks & Workflow Overview

### 1. **Setup GitHub Actions Workflow**

- Created a workflow file at `.github/workflows/docker.yml`
- The workflow triggers on every push to the `main` branch.
- The pipeline performs:

  - Code checkout
  - Docker image build using Buildx
  - Image push to Docker Hub
  - Vulnerability scan using Trivy
  - Slack notification on success/failure

  <img src="images/Screenshot 2025-05-02 at 17.10.02.png" alt="image of docker.yml screenshot">

### 2. **Docker Setup**

- Created a `Dockerfile` inside `static-web/` directory along with `index.html`.

<img src="images/Screenshot 2025-05-02 at 17.10.02.png" alt="image of dockerfile screenshot">

- Folder structure:
  ├── DOCKER/ ├── .github/ │ └── workflows/ │ └── docker.yml ├── static-web/ │ ├── Dockerfile │ └── index.html └── README.md

## Creating GitHub Actions Secrets Configuration

Added the following secrets under my github repo **Settings > Secrets and Variables > Actions**:

| Secret Name       | Description                   |
| ----------------- | ----------------------------- |
| `DOCKER_USERNAME` | Docker Hub username           |
| `DOCKER_PASSWORD` | Docker Hub **Access Token**   |
| `SLACK_WEBHOOK`   | Webhook URL for Slack channel |

<img src="images/Screenshot 2025-05-02 at 13.56.51.png" alt="screenshot of github settings">

> Note: Docker **Access Token** was generated from Docker Hub:
>
> - Go to [Docker Hub Security Settings](https://hub.docker.com/settings/security)
> - Create a token with **Read, Write, and Delete** permissions
> - Use this token in place of your password

## GitHub Actions Workflow File Summary (`docker.yml`)

```
name: Docker Build and Push

on:
push:
  branches:
    - main

jobs:
build-and-push:
  runs-on: ubuntu-latest

  steps:
    - name: Checkout code
      uses: actions/checkout@v3

    - name: Set up Docker Buildx
      uses: docker/setup-buildx-action@v2

    - name: Log in to Docker Hub
      uses: docker/login-action@v2
      with:
        username: ${{ secrets.DOCKER_USERNAME }}
        password: ${{ secrets.DOCKER_PASSWORD }}

    - name: Extract metadata (tags, labels)
      id: meta
      uses: docker/metadata-action@v5
      with:
        images: sheezylion/docker-static-image

    - name: Build and push Docker image
      uses: docker/build-push-action@v5
      with:
        context: ./static-web
        file: ./static-web/Dockerfile
        push: true
        tags: |
          sheezylion/docker-static-image:latest
          sheezylion/docker-static-image:${{ github.sha }}

    - name: Scan Docker image with Trivy
      uses: aquasecurity/trivy-action@master
      with:
        image-ref: sheezylion/docker-static-image:latest

    - name: Notify on success
      if: success()
      uses: rtCamp/action-slack-notify@v2
      env:
        SLACK_WEBHOOK: ${{ secrets.SLACK_WEBHOOK }}
        SLACK_COLOR: good
        SLACK_MESSAGE: "✅ Docker image built and pushed successfully!"

    - name: Notify on failure
      if: failure()
      uses: rtCamp/action-slack-notify@v2
      env:
        SLACK_WEBHOOK: ${{ secrets.SLACK_WEBHOOK }}
        SLACK_COLOR: danger
        SLACK_MESSAGE: "❌ Docker image build or push failed!"
```

## How to get a Slack Webhook URL

- Go to: https://api.slack.com/apps

- Click “Create New App”

<img src="images/Screenshot 2025-05-02 at 14.13.34.png">

- Choose “From scratch”, give it a name (e.g. GitHub Notifications) and choose your Slack workspace
  <img src="images/Screenshot 2025-05-02 at 14.17.06.png">

- In the left sidebar, go to “Incoming Webhooks”

- Toggle “Activate Incoming Webhooks” to ON

<img src="images/Screenshot 2025-05-02 at 14.18.02.png">

- Scroll down and click “Add New Webhook to Workspace”

- Choose the channel where you want the notification to appear (e.g. #devops, #general, or your own private messages)

<img src="images/Screenshot 2025-05-02 at 14.18.50.png">

- Click Allow

- Copy the Webhook URL (it will look something like this:
  https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX)

<img src="images/Screenshot 2025-05-02 at 14.20.31.png">

- Go to GitHub > Repo > Settings > Secrets and Variables > Actions

- Click “New repository secret”

**Set:**

- Name: SLACK_WEBHOOK

- Value: (paste the webhook URL)

<img src="images/Screenshot 2025-05-02 at 14.20.19.png">

## Common Errors & How We Fixed Them

### Error Message 1

- failed to read dockerfile: open Dockerfile: no such file or directory. This caused a build failure when pushed to git and also we got a notification on slack for build failure

<img src="images/Screenshot 2025-05-02 at 14.33.50.png">

<img src="images/Screenshot 2025-05-02 at 14.34.05.png">

- Root cause: Wrong context and file paths in the workflow

- solution: Reorganized files into static-web/, updated context and file values

### Error MEssage 2

- failed to authorize: failed to fetch oauth token... 401 Unauthorized
- ROot cause: Docker token did not have proper permissions
- Solution: Created a new Docker token with read, write, delete permissions

## Final Status

After multiple iterations, the following was achieved:

- Docker image successfully built and pushed on every main branch update

<img src="images/Screenshot 2025-05-02 at 16.46.59.png">

- Slack notifications sent based on result

<img src="images/Screenshot 2025-05-02 at 16.47.51.png">

- Docker Hub integration secured and functional

<img src="images/Screenshot 2025-05-02 at 16.48.57.png">

## Lessons Learned

- Always double-check file paths (context, file) in workflows

- Use access tokens instead of Docker passwords

- Folder structure and consistent naming reduce confusion

- Error messages guide you—read them line by line

- CI/CD setup is a continuous learning process
