## Module for creating cron based lambdas

What it does:
- Creates a role for lambda
- Creates and attaches policy to the role
- Creates Cloudwatch cron, connects it to lambda and grants permission to run lambda.
- Creates lambda function

## Module Variables
- `region` - The AWS region. Defaults to us-east-1"
- `enabled` - bool, defaults to `true`
- `lambda_name` - Name for lambda function
- `project` - Project lambda belongs to
- `runtime` - Runtime for lambda function
- `handler` - Handler for lambda function
- `lambda_zipfile` - Path to zip file that contains lambda function
- `source_code_hash` - The hash for lambda Zip file"
- `lambda_policy_document` - Path to policy document for [lambda function](http://docs.aws.amazon.com/lambda/latest/dg/intro-permission-model.html#lambda-intro-execution-role)
- `description` - Description for lambda function
- `timeout` - Timeout for lambda function
- `subnet_ids` - The list of subnets functions belongs to 
- `security_group_ids` - The list of security groups

## Usage:
```sh
module "lambda_test" {    
    source              = "../../terraform/modules/aws_lambda_cron"
    lambda_name         = "test_inventory"
    runtime             = "python3.6"
    lambda_zipfile      = "${path.module}/function/function.zip"
    source_code_hash    = "${base64sha256(file("function/function.zip"))}"
    handler             = "redshift_inventory.lambda_handler"
    schedule_expression = "cron(0 */2 * * ? *)"
    policy_document     = "${file("policies/lambda-policy.json")}"

    # vpc_config parameters
    # don't set if you want lambda run off VPC
    # refer to terraform documentation
    # both variables are lists
    subnet_ids          = ["subnet-7e19af35"]
    security_group_ids  = ["sg-aa4519da"]
    # end vpc_config parameters

    project = "Infra"
    description = "Test function"
}
```
## Outputs
- `lambda_arn` - the ARN for lmbda
- `role_name` - the NAME for the role
- `role_arn` - the ARN for role

## Author
This module is created and maintained by [leandevops](https://github.com/leandevops)
