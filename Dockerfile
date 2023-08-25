# Use the Alpine Linux base image
FROM alpine:latest

# Install required packages
RUN apk --no-cache add openssl jq bash

# Set the working directory
WORKDIR /app

# Copy the script and cipher suite JSON files into the container
COPY check_tls_ciphers.sh .
COPY ciphers.json .

# Make the script executable
RUN chmod +x check_tls_ciphers.sh

# Run the script
CMD ["bash", "check_tls_ciphers.sh"]

