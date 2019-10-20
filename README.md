This terraform project comprises 2 files: 
    00. variables.tf and 
    01. terraform-FTGT-AutoScale.tf

The main script is "01. terraform-FTGT-AutoScale.tf"

It deploys Fortigates as part of an AutoScale group behind a Network Load Balancer on AWS using the CloudFormation templates found in Rls 1.0.6 found on the projects page of the Fortinet Github site: https://github.com/fortinet/fortigate-autoscale/releases 
Deployment uses the Pay As You Go (PAYG) model 

The script automates the instructions for "Deploying auto scaling on AWS without Transit Gateway integration" found on the following Fortinet Docs location: https://docs.fortinet.com/vm/aws/fortigate/6.2/aws-cookbook/6.2.0/543390/deploying-auto-scaling-on-aws-without-transit-gateway-integration 

Uses the CloudFormation template "Deployment into a new VPC (end-to-end deployment)". This option builds a new AWS environment consisting of the VPC, subnets, FortiGate-VMs, security groups, and other infrastructure components, and then deploys FortiGate Autoscale for AWS into this new VPC.

The default parameters are applied when creating the VPC resources. 
Some parameters need to be specified - see file 00. variables.tf

The script assumes the prerequisites of the above doc have been met:
- Need to have a valid Key Pair in the AWS region used
- Need to have copied the CloudFormation templates etc into S3 bucket in the same AWS region, this bucket should be made public
- Need to have an ongoing subscription to FortiGate on-demand (PAYG) in AWS Marketplace
