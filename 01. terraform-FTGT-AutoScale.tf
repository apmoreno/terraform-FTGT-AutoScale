#Need to have copied CloudFormation templates etc into S3 bucket in AWS
#Need to have an ongoing subscription to FortiGate on-demand (PAYG) in AWS Marketplace

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
  tags = {
        "Name" : "FTGT-AutoScale"
    }
  
  template_url="https://apollinaire-fortigate-autoscale.s3.amazonaws.com/deployment-files/templates/workload-master.template"

}