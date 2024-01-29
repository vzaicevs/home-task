#!/usr/bin/env bash

set -e
set -u
set -o pipefail

### ENVIRONMENT VARIABLES
export APP_NAME="sonarqube"
export APP_ENV="prod"
export APP_URL="sonarqube-home-task.internal.loc"
export DB_NAME="sonarqube"
export DB_USER="sonarqube"
export DB_PASSWORD="S0nar-qube-Pwd"

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

### Check terraform and kubeconfig context
if ! command -v terraform >/dev/null; then
  terminate_with_error "Terraform is not found, please run setup-environment script"
fi

if ! minikube update-context >/dev/null; then
  terminate_with_error "Failed to update kubectl context, please run setup-environment script first"
fi

### Deploy the app

terraform -chdir=./terraform init
terraform -chdir=./terraform plan \
  -var app_name="$APP_NAME" \
  -var app_env="$APP_ENV" \
  -var app_url="$APP_URL" \
  -var db_user="$DB_USER" \
  -var db_password="$DB_PASSWORD" \
  -var db_name="$DB_NAME"

terraform -chdir=./terraform apply -auto-approve \
  -var app_name="$APP_NAME" \
  -var app_env="$APP_ENV" \
  -var app_url="$APP_URL" \
  -var db_user="$DB_USER" \
  -var db_password="$DB_PASSWORD" \
  -var db_name="$DB_NAME"

if [ $? -ne 0 ]; then
    terminate_with_error "Deployment failed, please review output and logs"
  else
    print_success "Deployment completed successfully"
  fi

 
