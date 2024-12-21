# audio-library
For our interns
text
# Audiobook Library Project

A low-cost, 3-tier digital audiobook library application using AWS, Terraform, Python, and MariaDB.

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

## Overview

This project creates a serverless audiobook library with:
- Frontend: Static website hosted on Amazon S3
- Backend: AWS Lambda functions with Python
- Database: Amazon RDS for MariaDB
- Infrastructure: Managed with Terraform

Features:
- Upload audiobooks
- Browse and search the library
- Play audiobooks (basic functionality)

## Prerequisites

Ensure you have the following installed and configured:
- AWS Account: https://aws.amazon.com/
- AWS CLI: https://aws.amazon.com/cli/ (configured with your credentials)
- Terraform (v1.0.0+): https://www.terraform.io/downloads.html
- Python (v3.8+): https://www.python.org/downloads/
- Node.js (v14.x+): https://nodejs.org/en/download/
- Git: https://git-scm.com/downloads

## Installation

1. Clone the repository:
git clone https://github.com/ChiefSemga/audio-library.git
cd audiobook-library
text

2. Install Python dependencies:
pip install boto3 pymysql
text

3. Install Node.js dependencies (if any):
npm install
text

## Configuration

1. AWS CLI configuration:
aws configure
text
Enter your AWS access key ID, secret access key, and preferred region.

2. Update `main.tf`:
- Replace `your-audiobook-library-bucket` with a unique S3 bucket name
- Update `region` if necessary
- Change MariaDB password in `aws_db_instance` resource

3. Update `lambda_function.py`:
- Replace `your-audiobook-library-bucket` with your S3 bucket name

4. Update `index.html`:
- Replace `YOUR_API_GATEWAY_URL` with your API Gateway URL (available after deployment)
- Replace `YOUR_S3_BUCKET_URL` with your S3 bucket URL

## Deployment

1. Initialize Terraform:
terraform init
text

2. Preview changes:
terraform plan
text

3. Apply changes:
terraform apply
text
Type 'yes' when prompted.

4. Note the outputs, including API Gateway URL and S3 bucket URL.

5. Deploy Lambda function:
zip lambda_function.zip lambda_function.py
aws lambda update-function-code --function-name audiobook_library_backend --zip-file fileb://lambda_function.zip
text

6. Upload frontend to S3:
aws s3 cp index.html s3://your-audiobook-library-bucket/index.html
text

7. Configure CORS for API Gateway:
- Go to AWS Management Console > API Gateway
- Select your API
- Click "Actions" > "Enable CORS"
- Click "Enable CORS and replace existing CORS headers"

## Usage

1. Access the application:
- Open the S3 website URL (from Terraform outputs) in a web browser

2. Upload an audiobook:
- Click "Upload Audiobook"
- Fill in the title and author
- Select an audio file
- Click "Upload"

3. Browse the library:
- Scroll through the list of audiobooks
- Click on an audiobook to view details or play

## Testing

To test for vulnerabilities using SonarQube:

1. Install and run SonarQube:
docker run -d --name sonarqube -p 9000:9000 sonarqube:latest
text

2. Access SonarQube:
- Open http://localhost:9000 in a web browser
- Log in with default credentials (admin/admin)
- Change the password when prompted

3. Create a new project:
- Click "Create new project"
- Enter project name and key (e.g., "AudiobookLibrary")
- Select "Locally" for analysis method

4. Generate a token:
- In "Provide a token" step, click "Generate"
- Save the generated token

5. Install SonarScanner:
- Download and install SonarScanner for your OS: https://docs.sonarqube.org/latest/analysis/scan/sonarscanner/

6. Create `sonar-project.properties` in project root:
sonar.projectKey=AudiobookLibrary
sonar.sources=.
sonar.host.url=http://localhost:9000
sonar.login=YOUR_GENERATED_TOKEN
text

7. Run analysis:
sonar-scanner
text

8. View results:
- Return to SonarQube web interface
- Navigate to your project
- Review identified issues, focusing on "Vulnerabilities" and "Security Hotspots"

9. Address vulnerabilities:
- Review and fix code based on SonarQube's recommendations

10. Re-run analysis:
 ```
 sonar-scanner
 ```

## Troubleshooting

1. AWS Permissions:
- Ensure AWS CLI is configured with correct credentials
- Verify IAM user has necessary permissions

2. Terraform Errors:
- Check `main.tf` for syntax errors
- Ensure resource names are unique
- Verify AWS region is correct

3. Lambda Function Issues:
- Check CloudWatch logs for error messages
- Verify environment variables are set correctly
- Ensure Lambda has necessary permissions to access S3 and RDS

4. Database Connection Problems:
- Check RDS security group settings
- Verify database credentials in Lambda environment variables

5. S3 Website Access Issues:
- Ensure bucket policy allows public read access
- Verify correct S3 bucket URL is used

6. API Gateway Errors:
- Check CORS settings
- Verify API Gateway URL is correct in frontend code

## Contributing

1. Fork the repository
2. Create a new branch: `git checkout -b feature-branch-name`
3. Make changes and commit: `git commit -m 'Add some feature'`
4. Push to the branch: `git push origin feature-branch-name`
5. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
