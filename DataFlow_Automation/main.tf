provider "aws" {
  region = "ap-south-1"
}

# S3 Bucket

resource "aws_s3_bucket" "bucket" {
  bucket = "pratiyasa-tf-demo-bucket-2026"
}

# SQS Queue

resource "aws_sqs_queue" "queue" {
  name = "tf-demo-queue"
}

# IAM Role

resource "aws_iam_role" "lambda_role" {

  name = "lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "lambda.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

# CloudWatch Permission

resource "aws_iam_role_policy_attachment" "lambda_logs" {

  role = aws_iam_role.lambda_role.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# SQS Permission

resource "aws_iam_role_policy_attachment" "lambda_sqs" {

  role = aws_iam_role.lambda_role.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole"
}

# Lambda

resource "aws_lambda_function" "func" {

  filename = "lambda.zip"

  function_name = "print-object"

  role = aws_iam_role.lambda_role.arn

  handler = "lambda.lambda_handler"

  runtime = "python3.12"

  source_code_hash = filebase64sha256("lambda.zip")

  depends_on = [
    aws_iam_role_policy_attachment.lambda_logs,
    aws_iam_role_policy_attachment.lambda_sqs
  ]
}

# Allow S3 → SQS

resource "aws_sqs_queue_policy" "allow_s3" {

  queue_url = aws_sqs_queue.queue.id

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "s3.amazonaws.com"
        }

        Action = "sqs:SendMessage"

        Resource = aws_sqs_queue.queue.arn

        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_s3_bucket.bucket.arn
          }
        }
      }
    ]
  })
}

# S3 → SQS

resource "aws_s3_bucket_notification" "notify" {

  bucket = aws_s3_bucket.bucket.id

  queue {

    queue_arn = aws_sqs_queue.queue.arn

    events = [
      "s3:ObjectCreated:*"
    ]
  }

  depends_on = [
    aws_sqs_queue_policy.allow_s3
  ]
}

# SQS → Lambda

resource "aws_lambda_event_source_mapping" "sqs_trigger" {

  event_source_arn = aws_sqs_queue.queue.arn

  function_name = aws_lambda_function.func.arn

  batch_size = 1

  depends_on = [
    aws_iam_role_policy_attachment.lambda_sqs
  ]
}








zip lambda.zip lambda.py





