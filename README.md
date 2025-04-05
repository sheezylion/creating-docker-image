# Docker Static Web Page Deployment
This project demonstrates how to create a Docker image using a basic **index.html** file served via Apache2 on Ubuntu, all containerized using Docker. By the end, you'll be able to access your HTML web page by visiting **localhost:80** on your browser.

## Prerequisites
Make sure the following are installed on your local machine:

- Docker Engine

- Basic understanding of Docker CLI commands

- Internet connection (for pulling base images and installing packages)

## Project Structure

```
/project-directory
│
├── Dockerfile
└── index.html
```

## Step-by-Step Guide to Building the Docker Image
1. Create a Dockerfile
Inside your project folder, create a file named Dockerfile (without any extension) and paste the following code:

```
# Use Ubuntu as the base image
FROM ubuntu:latest

# Update package manager and install Apache2
RUN apt update -y && apt install apache2 -y

# Copy the HTML file from local directory to Apache's root directory
COPY index.html /var/www/html/

# Run Apache in the foreground
CMD ["/usr/sbin/apachectl", "-D", "FOREGROUND"]
```

<img width="1672" alt="Screenshot 2025-04-05 at 12 59 36" src="https://github.com/user-attachments/assets/52088347-6a24-4e69-9237-833beb8f4ec8" />

## Explanation:
- FROM ubuntu:latest: Starts from the latest Ubuntu image.

- RUN:

  - apt update -y: Updates the list of available packages.

  - apt install apache2 -y: Installs Apache2 web server.

- COPY index.html /var/www/html/: Copies your index.html file into the default web directory used by Apache.

- CMD: Keeps Apache running in the foreground so the container stays alive.

COPY vs ADD:

- COPY is used to move files from your local system into the image.

- ADD can do everything COPY does but can also download from remote URLs and extract .tar files. For simplicity and best practice, COPY is preferred unless ADD is specifically needed.


## index.html Sample

Here’s a sample HTML file you can use, inspired by W3Schools:

```
<!DOCTYPE html>
<html>
<head>
  <title>My First Docker Webpage</title>
</head>
<body>
  <h1>Welcome to My Dockerized Website!</h1>
  <p>This is a simple static webpage served using Apache2 inside a Docker container.</p>
</body>
</html>
```

Save this file as index.html in the same directory as your Dockerfile.

<img width="1571" alt="Screenshot 2025-04-05 at 13 05 45" src="https://github.com/user-attachments/assets/1960ea13-ce45-41d8-bdc0-9c1c5446f81b" />

## Build the Docker Image
Open your terminal and navigate to the project directory where your Dockerfile and index.html are located, then run:

```
docker build -t ubuntu-webpage .
```
- -t ubuntu-webpage: Tags the image with the name ubuntu-webpage.

- . : Refers to the current directory as the build context.

<img width="1368" alt="Screenshot 2025-04-05 at 13 07 25" src="https://github.com/user-attachments/assets/143ea7e6-8bfa-41e7-b954-7b291037a075" />

Check if image was created:

```
docker images
```
<img width="1629" alt="Screenshot 2025-04-05 at 13 08 38" src="https://github.com/user-attachments/assets/a4542b3b-ffbd-438a-bb30-92e392bbe2fb" />

## Run the Docker Container
Now, start a container from your image:

```
docker run -d -p 80:80 --name webpage ubuntu-webpage
```
- -d: Detached mode (runs in the background).

- -p 80:80: Maps port 80 of the container to port 80 on your host.

- --name webpage: Names the container webpage.

- ubuntu-webpage: This is the name of the image we just built.

<img width="1620" alt="Screenshot 2025-04-05 at 13 10 15" src="https://github.com/user-attachments/assets/5dde0357-c87f-4a48-aea0-dd3a44ed6356" />

<img width="1672" alt="Screenshot 2025-04-05 at 13 11 29" src="https://github.com/user-attachments/assets/d4d281c0-b3aa-4bfd-aeb9-ee4d14193113" />


## Access the Web Page
Make sure Docker Engine is running, then:

1. Open your browser.

2. Go to: http://localhost:80

3. You should see your landing page served by Apache.
