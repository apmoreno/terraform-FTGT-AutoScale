# Deploys Fortigates as part of an AutoScale group behind a Network Load Balancer on AWS using the CloudFormation templates found in Rls 1.0.6 found on the projects page of the Fortinet Github site: https://github.com/fortinet/fortigate-autoscale/releases 
# Deployment uses the Pay As You Go (PAYG) model 
# This script automates the instructions for "Deploying auto scaling on AWS without Transit Gateway integration" found on the following Fortinet Docs location: https://docs.fortinet.com/vm/aws/fortigate/6.2/aws-cookbook/6.2.0/543390/deploying-auto-scaling-on-aws-without-transit-gateway-integration 
# This script assumes the prerequisites of the above doc have been met:
# Need to have a valid Key Pair in the AWS region used
# Need to have copied the CloudFormation templates etc into S3 bucket in the same AWS region, this bucket should be made public
# Need to have an ongoing subscription to FortiGate on-demand (PAYG) in AWS Marketplace

resource "aws_cloudformation_stack" "FTGT-AutoScale" {
  name = "FTGT-AutoScale-stack"

  parameters = {
    "QSS3BucketName"="apollinaire-fortigate-autoscale"
    "QSS3KeyPrefix"="deployment-files/"
    "FortiGatePskSecret"="FTNT"
    "FortiGateAdminCidr"="0.0.0.0/0"
    "KeyPairName"="AWS-FTGT"    
    
#    "AvailabilityZones"= "${var.availability-zones}"
#    
#   "AvailabilityZones" = [
#     "us-east-1a",
#    "us-east-1b"
#  ]
  
     "AvailabilityZones" = "us-east-1a, us-east-1b"
     "InternalLoadBalancerDnsName" = ""
  
  }
  
  on_failure = "ROLLBACK"
  
  capabilities = [
  "CAPABILITY_IAM", 
  "CAPABILITY_AUTO_EXPAND"
  ]
  
  tags = {
        "Name" : "FTGT-AutoScale"
    }
  
  template_url="https://apollinaire-fortigate-autoscale.s3.amazonaws.com/deployment-files/templates/workload-master.template"

} 
