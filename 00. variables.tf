terraform {
  required_version = ">= 0.12"
}

# variable "region" {
 #default = "us-east-1"
# 
#}


provider "aws" {
  region  = "us-east-1"
  version = "~> 2.31"
}

variable "availability-zones" {
  type = list(string)
  default = [
     "us-east-1a",
    "us-east-1b"
  ]
}

variable "tf_QSS3BucketName" {
default = "apollinaire-fortigate-autoscale"
}

###
#BEWARE: the following variable must end with a "/" or there will be a s3 access error:
# e.g.: default = "deployment-files/"

variable "tf_QSS3KeyPrefix" {
default = "deployment-files/"
}

variable "tf_FortiGatePskSecret" {
default = "FTNT"
}

variable "tf_FortiGateAdminCidr" {
default = "0.0.0.0/0"
}

variable "tf_KeyPairName" {
default = "AWS-FTGT"
}