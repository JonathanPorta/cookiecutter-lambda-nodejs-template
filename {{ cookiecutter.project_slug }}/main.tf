provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

# IAM Role for Lambda function
resource "aws_iam_role" "app_role" {
  name = "${var.app_name}_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
          "sts:AssumeRole"
      ],
      "Sid": "",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "app_role_policy" {
  name = "${var.app_name}_role_policy"
  role = aws_iam_role.app_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    },
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ses:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

# Create bucket to upload source
resource "aws_s3_bucket" "app_bucket" {
  bucket = "${var.app_name}-function"
}

# Upload source code to S3 bucket
resource "aws_s3_bucket_object" "app_source" {
  bucket = aws_s3_bucket.app_bucket.bucket
  key    = "source"
  source = "${var.app_name}.zip"
  etag   = md5(filebase64("${var.app_name}.zip"))
}

# AWS Lambda function
resource "aws_lambda_function" "app_function" {
  count            = length(var.function_handler)
  s3_bucket        = aws_s3_bucket_object.app_source.bucket
  s3_key           = aws_s3_bucket_object.app_source.key
  function_name    = "${var.app_name}_${element(var.function_name, count.index)}_function"
  role             = aws_iam_role.app_role.arn
  handler          = element(var.function_handler, count.index)
  runtime          = var.function_runtime
  timeout          = 300
  memory_size      = 1536
  source_code_hash = base64sha256(filebase64("${var.app_name}.zip"))

  environment {
    variables = {
      HOME_YET = "No."
    }
  }
}
