provider "aws" {
  region = "${var.region}"
}

module "module_test" {
  source              = "../../../module"
  lambda_name         = "test_lambda"
  runtime             = "python3.6"
  lambda_zipfile      = "${path.module}/function/function.zip"
  source_code_hash    = "${base64sha256(file("${path.module}/function/function.zip"))}"
  handler             = "test_lambda.lambda_handler"
  schedule_expression = "cron(0 04 * * ? *)"
  policy_document     = "${file("${path.module}/policies/lambda-policy.json")}"
  timeout             = 60

  project     = "test"
  description = "Test lambda function for testkitchen run"
}