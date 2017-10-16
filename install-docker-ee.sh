#!/bin/bash

# ********** Install Docker Enterprise Edition **********
sudo apt-get update -y

sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

curl -fsSL https://storebits.docker.com/ee/ubuntu/sub-fe7c336e-6219-4c02-bd49-7321f64f107f/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
   "deb [arch=amd64] https://storebits.docker.com/ee/ubuntu/sub-fe7c336e-6219-4c02-bd49-7321f64f107f/ubuntu \
   $(lsb_release -cs) \
   stable-17.06"

sudo apt-get update -y

sudo apt-get install docker-ee -y