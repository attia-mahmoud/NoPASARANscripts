#!/usr/bin/env bash

# Check for the first argument
if [ -z "$1" ]; then
  echo "First argument is missing. Please provide a CA URL."
  exit 1
fi

# Check for the second argument
if [ -z "$2" ]; then
  echo "Second argument is missing. Please provide a CA Fingerprint."
  exit 1
fi

# Bootstrap the CA configuration
step ca bootstrap --ca-url $1 --fingerprint $2
echo "Bootstrapped CA configuration successfully!"

# Add the SSH User Public Key
step ssh config --roots > /etc/ssh/ssh_user_key.pub && echo "TrustedUserCAKeys /etc/ssh/ssh_user_key.pub" >> /etc/ssh/sshd_config
echo "Added the SSH user public key to ssh config file successfully!"

# Start the SSH server
service ssh start

# REQUESTS_CA_BUNDLE=/home/root-ca.crt certbot certonly --manual --preferred-challenges dns -d master1.nopasaran.com --server https://192.168.123.2:8443/acme/acme/directory --email you@nopasaran.com

# Run the script to monitor incoming SSH connections
./ssh_monitor.sh &
echo "ssh_monitor script is running..."
