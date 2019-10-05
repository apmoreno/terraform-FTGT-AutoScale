terraform {
  required_version = ">= 0.12"
}

variable "region" {
 default = "us-east-1"
 
}

resource "aws_cloudformation_stack" "FTGT-AutoScale" {
  name = "FTGT-AutoScale-stack"

  parameters = {
    "QSS3BucketName"="apollinaire-fortigate-autoscale"
    "QSS3KeyPrefix"="deployment-files/"
    "FortiGatePskSecret"="FTNT"
    "FortiGateAdminCidr"="0.0.0.0/0"
    "KeyPairName"="AWS-FTGT"    
    
    "AvailabilityZones"=[
    "us-east-1a", 
    "us-east-1b",
    ]

  }
  
  on_failure = "ROLLBACK"
  tags = {
        "Name" : "FTGT-AutoScale"
    }
  
  template_url="https://apollinaire-fortigate-autoscale.s3.amazonaws.com/deployment-files/templates/workload-master.template"

  
}