require 'awspec'
require 'hcl/checker'

tf_state_file = 'terraform.tfstate'
module_hcl_file = 'tests/fixtures/tf_module/main.tf'

tf_state = JSON.parse(File.read(tf_state_file))

###############################################################
# lambda resource
###############################################################
# testing vars from module's HCL
lambda_hcl = HCL::Checker.parse(File.read(module_hcl_file))
lambda_name = lambda_hcl['module']['module_test']['lambda_name']
lambda_runtime = lambda_hcl['module']['module_test']['runtime']
lambda_handler = lambda_hcl['module']['module_test']['handler']
lambda_timeout = lambda_hcl['module']['module_test']['timeout']

# testing vars from .tfvars file
lambda_arn = tf_state['modules'][1]['outputs']['lambda_arn']['value'][0]
lambda_resource = tf_state['modules'][1]['resources']['aws_lambda_function.self']
lambda_description =  lambda_resource['primary']['attributes']['description']

# aws_iam_role
iam_role_resource = tf_state['modules'][1]['resources']['aws_iam_role.lambda_role']
iam_role_id = iam_role_resource['primary']['attributes']['name']
iam_role_description =  iam_role_resource['primary']['attributes']['description']

# aws_iam_policy
iam_policy_resource = tf_state['modules'][1]['resources']['aws_iam_policy.lambda-policy']
iam_policy_name = iam_policy_resource['primary']['attributes']['name']

# "aws_cloudwatch_event_rule" "cron"
cloudwatch_cron_resource = tf_state['modules'][1]['resources']['aws_cloudwatch_event_rule.cron']
cloudwatch_cron_name = cloudwatch_cron_resource['primary']['attributes']['id']
cloudwatch_cron_schedule = lambda_hcl['module']['module_test']['schedule_expression']

# Testing lambda
describe lambda(lambda_name) do
  it { should exist }
  its(:function_name) { should eq lambda_name }
  its(:function_arn) { should eq lambda_arn }
  its(:runtime) { should eq lambda_runtime }
  its(:handler) { should eq lambda_handler}
  its(:description) { should eq lambda_description }
  its(:timeout) { should eq lambda_timeout }
end

# Testing iam role
describe iam_role(iam_role_id) do
  it { should exist }
  its(:role_name) { should eq iam_role_id }  
  its(:description) { should eq iam_role_description }
  it { should have_iam_policy(iam_policy_name) }
end

# testing iam policy
describe iam_policy(iam_policy_name) do
  it { should exist }
  it { should be_attached_to_role(iam_role_id) }
end

# testing cloudwatch cron
describe cloudwatch_event(cloudwatch_cron_name) do
  it { should exist }
  its(:schedule_expression) { should eq cloudwatch_cron_schedule }
end