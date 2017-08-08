variable "username" {}
variable "aws_region"  { default = "us-east-1" }
variable "aws_profile" { default = "dev" }
variable "domain_name" { default = "ringrevenue.net" }
variable "root_volume_size" { default = 20 }
variable "key_name" { default = "staging" }
variable "instance_type" { default = "c3.xlarge" }
variable "environment" { default = "staging-ops" }
variable "instance_name" {}
variable "count" { default = 1 }
variable "subnet_id" {}
variable "associate_public_ip_address" { default = true }
variable "iam_instance_profile" {}
variable "chef_version" { default = "12.19.36" }
variable "chef_run_list" { type = "list" }
variable "route53_zone" { default = "Z25PEID9SD3I6P" }
variable "vpc_security_group_ids" { type = "list" }
