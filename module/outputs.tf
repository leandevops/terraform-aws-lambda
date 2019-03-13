##############################
# output variables
##############################
output "lambda_arn" {
  value = "${aws_lambda_function.self.*.arn}"
}

output "role_name" {
  value = "${aws_iam_role.lambda_role.name}"
}

output "role_arn" {
  value = "${aws_iam_role.lambda_role.arn}"
}
