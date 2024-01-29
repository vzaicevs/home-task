# home-task project
The task is to deploy the Sonarqube application Helm chart to a Minikube cluster using Terraform.

## Provision an environment
To provision the testing environment, please clone the repository to the local directory and run the *setup-environment.sh* script. It will check if Docker, Minikube, and Terraform are installed, and install them / start if required.

## Deploy an application
To deploy Sonarqube and PostgreSQL, please run the &*deploy-sonarqube.sh* script.