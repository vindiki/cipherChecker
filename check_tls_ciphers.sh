#!/bin/bash

# Set the server hostname and port
SERVER_HOST="onlinetoolsuat.ups.com"
SERVER_PORT="443"
#SERVER_IP="184.31.119.168"
SERVER_IP="104.112.207.194"

# Load  cipher suites from JSON file
ciphers_json=$(cat ciphers.json)

# Function to check a specific cipher suite for TLS 1.3
function check_tls13_cipher() {
  local cipher="$1"
  echo -n "Checking TLS 1.3 cipher $cipher... "
  result=$(echo -n "Q"| openssl s_client -connect "${SERVER_IP}:${SERVER_PORT}" -servername "${SERVER_HOST}" -tls1_3 -ciphersuites "$cipher" 2>&1)
  if echo "$result" | grep -q "Cipher is ${cipher}"; then
    echo "Supported"
  else
    echo "Not supported"
  fi
}

# Function to check a specific cipher suite for TLS 1.2
function check_tls12_cipher() {
  local cipher="$1"
  echo -n "Checking TLS 1.2 cipher $cipher... "
  result=$(echo -n "Q"| openssl s_client -connect "${SERVER_IP}:${SERVER_PORT}" -servername "${SERVER_HOST}" -tls1_2 -cipher "$cipher" 2>/dev/null)
  if echo "$result" | grep -q "Cipher is ${cipher}"; then
    echo "Supported"
  else
    echo "Not supported"
  fi
}

# Check each TLS 1.3 cipher suite individually
echo "TLS 1.3 Cipher Suites:"
for cipher in $(jq -r '.TLS13.cipher_suites[]' <<< "$ciphers_json"); do
  check_tls13_cipher "$cipher"
done

# Check each TLS 1.2 cipher suite individually
echo "TLS 1.2 Cipher Suites:"
for cipher in $(jq -r '.TLS12.cipher_suites[]' <<< "$ciphers_json"); do
  check_tls12_cipher "$cipher"
done
