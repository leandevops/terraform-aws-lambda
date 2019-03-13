# provider
provider "aws" {
  region = "${var.region}"
}

# create role and policies
resource "aws_iam_role" "lambda_role" {
  name        = "${var.lambda_name}_role"
  description = "Role for ${var.lambda_name} Lambda function [Created with Terraform]"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda-policy" {
  name        = "${var.lambda_name}_policy"
  description = "Defines resources ${var.lambda_name} lambda function has access to [Created with Terraform]"

  policy = "${var.policy_document}"
}

# attach policy to role
resource "aws_iam_role_policy_attachment" "attach-policy" {
  role       = "${aws_iam_role.lambda_role.name}"
  policy_arn = "${aws_iam_policy.lambda-policy.arn}"
}

# creates lambda
resource "aws_lambda_function" "self" {
  #count = "${var.enabled}"

  runtime          = "${var.runtime}"
  function_name    = "${var.lambda_name}"
  filename         = "${var.lambda_zipfile}"
  role             = "${aws_iam_role.lambda_role.arn}"
  handler          = "${var.handler}"
  source_code_hash = "${var.source_code_hash}"
  description      = "${var.description} [Created with Terraform]"

  publish = true
  timeout = "${var.timeout}"

  vpc_config = {
    subnet_ids         = "${var.subnet_ids}"
    security_group_ids = "${var.security_group_ids}"
  }

  tags = {
    name         = "${var.lambda_name}"
    createdWith  = "Terraform"
    BUDGET_GROUP = "${var.project}"
  }
}

# create CloudWatch cron
resource "aws_cloudwatch_event_rule" "cron" {
  count               = "${var.enabled}"
  name                = "${var.lambda_name}-cron"
  description         = "Sends event to ${var.lambda_name} cron based [Created with Terraform]"
  schedule_expression = "${var.schedule_expression}"
}

resource "aws_cloudwatch_event_target" "lambda" {
  count     = "${var.enabled}"
  target_id = "runLambda"
  rule      = "${aws_cloudwatch_event_rule.cron.name}"
  arn       = "${aws_lambda_function.self.arn}"
}

resource "aws_lambda_permission" "cloudwatch" {
  count         = "${var.enabled}"
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.self.arn}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.cron.arn}"
}
