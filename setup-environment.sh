#!/usr/bin/env bash

set -e
set -u
set -o pipefail

##########################################################################################
### This script setup environment - check docker and minikube and install if requried
##########################################################################################

### Helper functions

# Colors for print functions
color_green='\033[0;32m' # Green
color_red='\033[0;31m' # Red
color_blue='\033[0;34m' # Blue
color_magenta='\033[0;35m' # Magenta
color_cyan='\033[0;36m' # Cyan
color_reset='\033[0m' # No Color

SYMBOL_START="\033[1m➤\033[0m"
SYMBOL_DONE="\033[1m✔\033[0m"

# Print functions
function terminate_with_error {
  retval=$?
  msg=${1:-'no message'}
  printf "${color_red}[ERROR] ${msg}${color_reset}\n" >&2
  print_time
  exit 1
}
function print_success {
  msg=${1:-'no message'}
  printf "${color_green}[SUCCESS] ${msg}${color_reset}\n"
}
function print_info {
  msg=${1:-'no message'}
  printf "${color_blue}[INFO] ${msg}${color_reset}\n"
}
function print_warning {
  msg=${1:-'no message'}
  printf "${color_cyan}[WARNING] ${msg}${color_reset}\n"
}
function print_time {
  now=$(date +"%Y.%m.%d %T.%3N")
  printf "${color_magenta}[TIME] ${now}${color_reset}\n"
}

# Check docker
print_info "Checking docker.."
if ! command -v docker >/dev/null; then
  print_info "Installing docker.."
  curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
  sudo sh /tmp/get-docker.sh
  sudo systemctl enable docker --now
  sudo usermod -aG docker $USER
else
  print_success "Docker found"
fi

if ! docker ps ; then
  print_warning "User have been added to the docker group. Please logoff and login to reload groups and run the script again"
  terminate_with_error "Docker is not available or access denied"
fi


# Check minikube
print_info "Checking minikube.."
if ! command -v minikube >/dev/null; then
  print_warning "Minikube not found, installing"
  curl -L -o /tmp/minikube-linux-amd64 https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
  sudo install /tmp/minikube-linux-amd64 /usr/local/bin/minikube
else
  print_success "minikube found"
fi

if ! minikube status >/dev/null; then
  print_warning "Minikube is not started, starting.."
  minikube start
  if [ $? -ne 0 ]; then
    terminate_with_error "failed to start minikube"
  else
    print_success "minikube started"
  fi
fi

### enable required minikube addons: storage, ingress, metrics-server
print_info "Enabling required minikube addons.."

if ! minikube addons enable metrics-server >/dev/null; then
  terminate_with_error "unable to enable metrics-server addon"
  else print_success "metrics-server OK"
fi
if ! minikube addons enable storage-provisioner >/dev/null; then
  terminate_with_error "unable to enable storage-provisioner addon"
  else print_success "storage-provisioner OK"
fi
if ! minikube addons enable ingress >/dev/null; then
  terminate_with_error "unable to enable ingress addon"
  else print_success "ingress OK"
fi

# Check terraform
print_info "Checking terraform.."
if ! command -v terraform >/dev/null; then
  print_warning "Terraform is not found, installing"

  if command -v apt ; then
    sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
    sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" -y
    sudo apt-get update && sudo apt-get -y install terraform
    print_success "Terraform installed"
  elif command -v yum ; then
    sudo yum install -y yum-utils
    sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
    sudo yum -y install terraform
    print_success "Terraform installed"
  fi
else
  print_success "terraform found"
fi

print_success "environment is ready, please run ./deploy-sonarqube.sh"