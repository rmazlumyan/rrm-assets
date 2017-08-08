variable "username" {}
variable "dev_account_number" { default = "092733289512" }
variable "prod_account_number" { default = "760016601824" }
variable "aws_region"  { default = "us-east-1" }
variable "aws_profile" { default = "dev" }
variable "aws_dev_profile" { default = "dev" }
variable "aws_prod_profile" { default = "prod" }
variable "deploy_user" { default = "ringrevenue" }
variable "domain_name" { default = "ringrevenue.net" }
variable "root_volume_size" { default = 20 }
variable "key_name" { default = "staging" }
variable "common_instance_type" { default = "c3.xlarge" }
variable "environment" { default = "staging-ops" }
variable "instance_name" {}
variable "count" { default = 1 }
variable "subnet_id" {}
variable "associate_public_ip_address" { default = true }
variable "iam_instance_profile" { default = "ir-kafka" }
variable "chef_version" { default = "12.19.36" }
variable "chef_run_list" { 
  type    = "list" 
  default = ["role[kafka]"]
}
variable "route53_zone" { default = "Z25PEID9SD3I6P" }
variable "state_buckets" {
  default = {
    dev  = "invocadev-infrastructure"
    prod = "invoca-infrastructure"
  }
}
variable "vpc_security_group_ids" { type = "list" }
