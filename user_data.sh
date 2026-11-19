#!/bin/bash

apt-get update -y
apt-get install -y stress-ng

# Generate CPU load for 5 minutes
stress-ng --cpu 1 --timeout 300s --metrics-brief
