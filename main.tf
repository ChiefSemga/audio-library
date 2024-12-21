provider "aws" {
  region = "us-east-1"
}

# S3 Bucket for static website and audiobook storage
resource "aws_s3_bucket" "website_and_storage" {
  bucket = "your-audiobook-library-bucket"
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website_and_storage.id

  index_document {
    suffix = "index.html"
  }
}

# Lambda function for backend
resource "aws_lambda_function" "backend" {
  filename      = "lambda_function.zip"
  function_name = "audiobook_library_backend"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"

  environment {
    variables = {
      DB_HOST     = aws_db_instance.mariadb.endpoint
      DB_USER     = aws_db_instance.mariadb.username
      DB_PASSWORD = aws_db_instance.mariadb.password
      DB_NAME     = aws_db_instance.mariadb.name
    }
  }
}

# IAM role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "audiobook_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Attach necessary policies to the Lambda role
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_role.name
}

resource "aws_iam_role_policy_attachment" "lambda_s3" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role       = aws_iam_role.lambda_role.name
}

# RDS MariaDB instance
resource "aws_db_instance" "mariadb" {
  engine               = "mariadb"
  engine_version       = "10.5"
  instance_class       = "db.t3.micro"
  db_name              = "audiobookdb"
  username             = "admin"
  password             = "your_password"
  allocated_storage    = 20
  skip_final_snapshot  = true
  publicly_accessible  = false
}

# API Gateway
resource "aws_api_gateway_rest_api" "audiobook_api" {
  name = "audiobook-library-api"
}

resource "aws_api_gateway_resource" "audiobooks" {
  rest_api_id = aws_api_gateway_rest_api.audiobook_api.id
  parent_id   = aws_api_gateway_rest_api.audiobook_api.root_resource_id
  path_part   = "audiobooks"
}

resource "aws_api_gateway_method" "audiobooks_get" {
  rest_api_id   = aws_api_gateway_rest_api.audiobook_api.id
  resource_id   = aws_api_gateway_resource.audiobooks.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.audiobook_api.id
  resource_id = aws_api_gateway_resource.audiobooks.id
  http_method = aws_api_gateway_method.audiobooks_get.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.backend.invoke_arn
}

resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on = [aws_api_gateway_integration.lambda_integration]

  rest_api_id = aws_api_gateway_rest_api.audiobook_api.id
  stage_name  = "prod"
}

