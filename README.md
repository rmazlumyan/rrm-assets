# rrm-assets

## Create VPC
1. Review terraform config files (*.tf) and CloudFormation template (../CloudFormation/CreateVPC.template)
2. Insure that you have an AWS IAM user access keys with access to VPC and S3
3. Set the AWS_ACCESS_KEY and AWS_SECRET_KEY environment variables    
    ```export AWS_ACCESS_KEY=your-aws-access-key-id```   
    ```export AWS_SECRET_KEY=your-aws-secret-key```
4. Run script to create VPC   
    ```$ ./apply.sh <region> <vpcname>  (eg. apply.sh us-west-2 dev-us-west-2)```
5. Observe that the share state file is updated in s3 (https://s3.amazonaws.com/invocadev-infrastructure/terraform-state/dev-us-west-2).   
   The shared state file can be referenced by multiple team members to perform Terraform updates to the VPC and to query the VPC resources for creation of other objects in the VPC.

## Update VPC
1. Make necessary changes to terraform config files (*.tf) and CloudFormation template (../CloudFormation/CreateVPC.template)
2. Make a small change to Cloudformation parameters defined in "aws_cloudformation_stack" resource.   
   eg. Set CreateNewZone = "false" and change ZoneName string.   
   This is needed due to bug in Terraform where Cloudformation parameters are not sent during updates if
   no changes are seen in the parameters
4. Re-run script to update VPC    
    ```$ ./apply.sh <region> <vpcname>  (eg. apply.sh us-west-2 dev-us-west-2```

## Destroy VPC
1. Edit vpc.tf and comment out "prevent_destroy = true" safety block
1. Issue terraform destroy vpc command    
    ```$ ./destroy.sh <region> <vpcname> (eg. destroy.sh us-west-2 dev-us-west-2)```
1. Remove VPC in AWS Web Console
   1. Login to AWS web console and go to VPC service section
   2. Select the VPC and delete
   3. Verify that the Route53 Hosted Zone that was created earlier is still there (manuall delete all the records and delete the zone if necessary)
   4. Verify that there are no remnants of your VPC (subnets, nat gateways, etc)
