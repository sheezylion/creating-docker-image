FROM ubuntu:latest

# Update package manager and install Apache2
RUN apt update -y && apt install apache2 -y

# Copy the HTML file from local directory to Apache's root directory
COPY index.html /var/www/html/

# Run Apache in the foreground
CMD ["/usr/sbin/apachectl", "-D", "FOREGROUND"]
