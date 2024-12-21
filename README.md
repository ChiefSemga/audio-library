# Audiobook Library Project

A low-cost, 3-tier digital audiobook library application using **AWS**, **Terraform**, **Python**, and **MariaDB**.

---

## Table of Contents
- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Deployment](#deployment)
- [Usage](#usage)
- [Testing](#testing)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

---

## Overview
This project creates a serverless audiobook library with:
- **Frontend**: Static website hosted on Amazon S3  
- **Backend**: AWS Lambda functions with Python  
- **Database**: Amazon RDS for MariaDB  
- **Infrastructure**: Managed with Terraform  

### Features:
- Upload audiobooks
- Browse and search the library
- Play audiobooks (basic functionality)

---

## Prerequisites
Ensure you have the following installed and configured:
- An **AWS Account**
- **AWS CLI** (configured with your credentials)
- **Terraform** (v1.0.0+)
- **Python** (v3.8+)
- **Node.js** (v14.x+)
- **Git**

---

## Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/audiobook-library.git
   cd audiobook-library

Install Python dependencies:

pip install boto3 pymysql


Install Node.js dependencies (if applicable):
npm install
Configuration
AWS CLI Configuration:

Run the following command:
aws configure
Enter your AWS Access Key ID, Secret Access Key, and preferred region.

Update main.tf:
Replace your-audiobook-library-bucket with a unique S3 bucket name.

Update the region if necessary.
Set the MariaDB password in the aws_db_instance resource.

Update lambda_function.py:
Replace your-audiobook-library-bucket with your S3 bucket name.

Update index.html:
Replace YOUR_API_GATEWAY_URL with your API Gateway URL (available after deployment).
Replace YOUR_S3_BUCKET_URL with your S3 bucket URL.

## Deployment
Initialize Terraform:

terraform init

terraform plan

Apply changes:
terraform apply
Type yes when prompted.
Note the API Gateway URL and S3 bucket URL in the outputs.

Deploy Lambda Function:

zip lambda_function.zip lambda_function.py
aws lambda update-function-code --function-name audiobook_library_backend --zip-file fileb://lambda_function.zip

Upload Frontend to S3:
aws s3 cp index.html s3://your-audiobook-library-bucket/index.html

Configure CORS for API Gateway:

Go to AWS Management Console > API Gateway.
Select your API.
Click Actions > Enable CORS.
Click Enable CORS and replace existing CORS headers.

Usage
Access the Application:
Open the S3 website URL (from Terraform outputs) in a web browser.
Upload an Audiobook:
Click Upload Audiobook.
Fill in the title and author.
Select an audio file.
Click Upload.
Browse the Library:
Scroll through the list of audiobooks.
Click on an audiobook to view details or play.
## Testing
To Test for Vulnerabilities Using SonarQube:

Install and Run SonarQube:

docker run -d --name sonarqube -p 9000:9000 sonarqube:latest
Access SonarQube: Open http://localhost:9000 in a web browser.
Log in with default credentials (admin/admin), then change the password.

Create a New Project:

Click Create new project.
Enter the project name and key (e.g., AudiobookLibrary).
Select Locally for the analysis method.
Generate a Token:

In the "Provide a token" step, click Generate.
Save the generated token.

Install SonarScanner:

Download and install SonarScanner for your OS.

Create sonar-project.properties in the project root:

properties
sonar.projectKey=AudiobookLibrary
sonar.sources=.
sonar.host.url=http://localhost:9000
sonar.login=YOUR_GENERATED_TOKEN

## Run Analysis:
sonar-scanner
View Results:

Return to the SonarQube web interface.
Navigate to your project.
Review identified issues, focusing on "Vulnerabilities" and "Security Hotspots".
Address Vulnerabilities:

Review and fix code based on SonarQube's recommendations.

Re-run Analysis:

sonar-scanner
Troubleshooting
AWS Permissions:
Ensure AWS CLI is configured with correct credentials.
Verify the IAM user has necessary permissions.

## Terraform Errors:
Check main.tf for syntax errors.
Ensure resource names are unique.
Verify the AWS region is correct.
Lambda Function Issues:
Check CloudWatch logs for error messages.
Verify environment variables are set correctly.
Ensure Lambda has permissions to access S3 and RDS.
Database Connection Problems:
Check RDS security group settings.
Verify database credentials in Lambda environment variables.
S3 Website Access Issues:
Ensure the bucket policy allows public read access.
Verify the correct S3 bucket URL is used.
API Gateway Errors:
Check CORS settings.
Verify the API Gateway URL is correct in the frontend code.

## Contributing
Fork the repository.

Create a new branch:
git checkout -b feature-branch-name

Make changes and commit:

git commit -m 'Add some feature'
Push to the branch:

git push origin feature-branch-name
Submit a pull request.
License
This project is licensed under the MIT License - see the LICENSE file for details.

---

