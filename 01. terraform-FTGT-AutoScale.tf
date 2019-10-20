# See README.md for details and prerequisites

resource "aws_cloudformation_stack" "FTGT-AutoScale" {
  name = "FTGT-AutoScale-stack"

  parameters = {
    "QSS3BucketName"="${var.tf_QSS3BucketName}"
    "QSS3KeyPrefix"="${var.tf_QSS3KeyPrefix}"
    "FortiGatePskSecret"="${var.tf_FortiGatePskSecret}"
    "FortiGateAdminCidr"="${var.tf_FortiGateAdminCidr}"
    "KeyPairName"="${var.tf_KeyPairName}"   
    
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
