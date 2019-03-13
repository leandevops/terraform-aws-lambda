##############################
# input variables
##############################
variable region {
  description = "The AWS region. Defaults to us-east-1"
  default     = "us-east-1"
}

variable enabled {
  default = true
}

variable lambda_name {
  description = "Name for lambda function"
}

variable project {
  description = "Project lambda belongs to"
}

variable runtime {
  description = "Runtime for lambda function"
}

variable handler {
  description = "Handler for lambda function"
}

variable lambda_zipfile {
  description = "Zip that contains lambda function"
}

variable source_code_hash {
  description = "The hash for lambda Zip file"
}

variable description {
  description = "Description for lambda function"
}

variable timeout {
  description = "Timeout for lambda function"
  default     = 30
}

variable policy_document {
  description = "policy document for lambda function"
}

variable schedule_expression {
  description = "Expression for CloudWatcvh cron"
}

variable subnet_ids {
  description = "List of VPC subnet ids that lambda belongs to"
  default     = []
}

variable security_group_ids {
  description = "List of security groups ids"
  default     = []
}
