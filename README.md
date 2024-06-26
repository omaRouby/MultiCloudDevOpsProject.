Here's an improved version of your README, with a Table of Contents, prerequisites, and arranged topics in the correct order:

---

# MultiCloud DevOps Project

## Table of Contents
1. [Project Overview](#project-overview)
2. [Prerequisites](#prerequisites)
3. [Project Components](#project-components)
4. [Detailed Steps](#detailed-steps)
    - [Terraform Configuration](#terraform-configuration)
    - [Ansible Configuration](#ansible-configuration)
    - [Jenkins Configuration](#jenkins-configuration)
    - [SonarQube Integration and Success Validation](#sonarqube-integration-and-success-validation)
    - [Validating OpenShift Deployment, Service, and Route](#validating-openshift-deployment-service-and-route)
    - [Validating Pipeline Success](#validating-pipeline-success)
5. [Conclusion](#conclusion)

## Project Overview
This project outlines the steps to set up an automated CI/CD pipeline using a combination of Terraform, Ansible, Jenkins, Docker, SonarQube, and OpenShift. The goal is to use Terraform to create the necessary infrastructure on AWS, configure Jenkins as the CI/CD server, deploy an application to an OpenShift cluster, and monitor the infrastructure using CloudWatch. Ansible will be used to configure the Jenkins server and install necessary tools and plugins.

![Project Diagram](https://github.com/omaRouby/MultiCloudDevOpsProject./blob/main/images/multicloud_devops_architecture.png)

## Prerequisites
- AWS account
- Basic knowledge of Terraform, Ansible, Jenkins, Docker, SonarQube, and OpenShift
- Installed tools:
    - Terraform
    - Ansible
    - Docker
    - OpenShift CLI
    - Jenkins

## Project Components
1. **Terraform**: Infrastructure as Code (IaC) tool for provisioning AWS resources.
2. **Ansible**: Configuration management tool for setting up Jenkins and other services on the EC2 instance.
3. **Jenkins**: CI/CD tool for automating the build and deployment process.
4. **Docker**: Containerization platform for deploying SonarQube and PostgreSQL.
5. **SonarQube**: Tool for static code analysis.
6. **OpenShift**: Kubernetes-based platform for deploying applications.
7. **CloudWatch**: Monitoring service to track CPU and memory usage.

## Detailed Steps

### 1. Terraform Configuration

#### Setting Up VPC and EC2 Instances
- **Files**: `terraform/main.tf`, `terraform/modules/vpc/main.tf`, `terraform/modules/ec2/main.tf`
- Define the VPC with necessary subnets, route tables, and internet gateways.
- Provision an EC2 instance within the VPC to serve as the Jenkins server.

![VPC](https://github.com/omaRouby/MultiCloudDevOpsProject./blob/main/images/my-vpc.png)
![EC2 Instances](https://github.com/omaRouby/MultiCloudDevOpsProject./blob/main/images/instances2.png)

#### Creating CloudWatch Alarms
- **Files**: `terraform/modules/cloudwatch-sns/main.tf`
- Configure CloudWatch alarms for CPU and memory usage on the EC2 instance to monitor performance.

![CloudWatch Alarms](https://github.com/omaRouby/MultiCloudDevOpsProject./blob/main/images/my-cloudwatch.png)
![CPU Utilization](https://github.com/omaRouby/MultiCloudDevOpsProject./blob/main/images/cpu-utilization.png)
![SNS Topic](https://github.com/omaRouby/MultiCloudDevOpsProject./blob/main/images/snstopic-email.png)
![](https://github.com/omaRouby/MultiCloudDevOpsProject./blob/main/images/email-cloudwatch.png)

#### Using Terraform Modules
- **Modules**: `vpc`, `ec2`, `security-groups`, `cloudwatch-sns`
- Organize the Terraform code into reusable modules for VPC, EC2, and CloudWatch.

#### Terraform Backend State
- Configure Terraform to use an S3 bucket for state storage and a DynamoDB table for state locking.

![Terraform State](https://github.com/omaRouby/MultiCloudDevOpsProject./blob/main/images/tfstate.png)
![State Object](https://github.com/omaRouby/MultiCloudDevOpsProject./blob/main/images/state-object.png)
![DynamoDB Table](https://github.com/omaRouby/MultiCloudDevOpsProject./blob/main/images/dynamo-db-table.png)

- Run `terraform apply`.

![Terraform Apply](https://github.com/omaRouby/MultiCloudDevOpsProject./blob/main/images/terraform-apply.png)

### 2. Ansible Configuration

#### Installing Docker and Docker Compose
- Use Ansible to install Docker and Docker Compose on the EC2 instance.

#### Deploying SonarQube and PostgreSQL
- Write a Docker Compose file to deploy SonarQube and PostgreSQL as containers.
- Use Ansible to execute the Docker Compose file on the EC2 instance.

#### Setting Up Jenkins
- Use Ansible to install Jenkins, the OpenShift CLI, and necessary Jenkins plugins.
- Configure Jenkins to use an initial admin password and install initial plugins.

#### Additional Jenkins Plugins
- Use Ansible to install additional plugins required for the CI/CD pipeline, such as the SonarQube scanner plugin and JDK.

- Run `playbook.yml`.

![Ansible Apply](https://github.com/omaRouby/MultiCloudDevOpsProject./blob/main/images/ansible-apply.png)

### 3. Jenkins Configuration

#### Integrating with OpenShift
- Use a service account token to link Jenkins with the OpenShift cluster.
- Configure Jenkins to interact with OpenShift using the OpenShift CLI.

![Service Account Token](https://github.com/omaRouby/MultiCloudDevOpsProject./blob/main/images/sa-token.png)

#### Jenkins Pipeline
- The Jenkins file uses the shared library [multicloud-sharedLibrary](https://github.com/omaRouby/multicloud-sharedLibrary.git).
- Define a Jenkins pipeline with stages for unit testing, static code analysis (SonarQube), Docker image build, and deployment to OpenShift.
- Use the following stages in the pipeline:
    - **Unit Test**: Run unit tests for the application.
    - **SonarQube Analysis**: Perform static code analysis using SonarQube.
    - **Docker Build and Push**: Build the application Docker image and push it to Docker Hub.
    - **Deployment**: Deploy the application to OpenShift.

### 4. SonarQube Integration and Success Validation

SonarQube is an essential tool for continuous inspection of code quality. It provides detailed reports on code vulnerabilities, bugs, code smells, and technical debt. In this project, SonarQube is integrated into the Jenkins pipeline to ensure that code quality checks are an integral part of the CI/CD process.

#### Steps to Integrate SonarQube

##### Install SonarQube
- SonarQube and PostgreSQL are deployed as Docker containers using Ansible.
- **Ansible Role**: `ansibile/roles/sonar`

    **Files**:
    - `ansibile/roles/sonar/compose/sonarqube_compose.yml` (Docker Compose file for SonarQube)
    - `ansibile/roles/sonar/tasks/main.yml` (Ansible tasks for SonarQube)

##### Generate SonarQube Token
- Log in to the SonarQube instance.
- Navigate to **My Account** -> **Security** -> **Generate Tokens**.
- Create a new token for Jenkins to use.

![Generate SonarQube Token](https://github.com/omaRouby/MultiCloudDevOpsProject./blob/main/images/generateSonar-token.png)

##### Configure SonarQube in Jenkins
- In Jenkins, go to **Manage Jenkins** -> **Configure System** -> **SonarQube Servers**.
- Add a new SonarQube server with the generated token.

![Add SonarQube URL in Jenkins](https://github.com/omaRouby/MultiCloudDevOpsProject./blob/main/images/add-sonarqubeurl.png)

##### Install SonarQube Scanner Plugin
- Ensure the SonarQube Scanner plugin is installed in Jenkins.

##### Define SonarQube Analysis in Jenkins Pipeline
- Utilize the SonarQube Scanner in the Jenkins pipeline for static code analysis.

#### Validating SonarQube Integration Success

##### SonarQube Dashboard
- Access the SonarQube dashboard to verify that the project has been analyzed.
- Check for code vulnerabilities, bugs, and code smells.

![SonarQube Dashboard](https://github.com/omaRouby/MultiCloudDevOpsProject./blob/main/images/sonar-check-passed.png)

By integrating SonarQube into your Jenkins pipeline, you ensure that code quality checks are automated and continuous. This helps in maintaining a high standard of code quality and reduces the risk of introducing defects into production. The detailed validation steps confirm that the integration is successful and working as expected.

### 5. Validating OpenShift Deployment, Service, and Route

#### Deployment Verification
- Access the OpenShift console or use the `oc` CLI tool to verify that the application deployment pods are running.
- Check the deployment status to ensure all pods are in the `Running` state without errors.

![Pod Status](https://github.com/omaRouby/MultiCloudDevOpsProject./blob/main/images/pod-console.png)

#### Service Availability
- Confirm that the Kubernetes services associated with your application are created and running.
- Check the service endpoints to ensure they are accessible and responding as expected.

![Service Status](https://github.com/omaRouby/MultiCloudDevOpsProject./blob/main/images/service-console.png)


#### Route Accessibility
- Use the route URL provided by OpenShift to access your deployed application in a web browser.
- Verify that the application loads correctly and functions as intended through the exposed route.

![Route Status](https://github.com/omaRouby/MultiCloudDevOpsProject./blob/main/images/route-console.png)
![Login Console](https://github.com/omaRouby/MultiCloudDevOpsProject./blob/main/images/login-console2.png)

### 6. Validating Pipeline Success

#### Pipeline Success
- Once the Jenkins pipeline runs successfully, you will see a green checkmark indicating that all stages have passed.
- This includes stages for building the Docker image, running unit tests, performing SonarQube analysis, and deploying to OpenShift.

![Pipeline Succeeded](https://github.com/omaRouby/MultiCloudDevOpsProject./blob/main/images/pipeline-succeeded-2.png)
![Sonar Quality Gate](https://github.com/omaRouby/MultiCloudDevOpsProject./blob/main/images/sonar-qualitygate.png)

#### SonarQube Analysis Success
- Verify that the SonarQube analysis has completed without any critical issues or code smells.
- Check the SonarQube dashboard for a green status, indicating that the quality gate has been passed.

![SonarQube Analysis](https://github.com/omaRouby/MultiCloudDevOpsProject./blob/main/images/sonar-check-passed.png)

#### Accessing the Application
- Use the route URL provided by OpenShift to access the deployed application and verify it is running as expected.

![Application Webpage](https://github.com/omaRouby/MultiCloudDevOpsProject./blob/main/images/ivolve-webpage.png)

### Conclusion
This project sets up a comprehensive CI/CD pipeline leveraging Terraform for infrastructure provisioning, Ansible for configuration management, Jenkins for continuous integration and deployment, Docker for containerization, SonarQube for code quality analysis, and OpenShift for application deployment. The infrastructure is monitored using CloudWatch to ensure optimal performance and availability. By following these steps, you can achieve a fully automated and scalable deployment pipeline.
