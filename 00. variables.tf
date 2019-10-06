terraform {
  required_version = ">= 0.12"
}

# variable "region" {
 #default = "us-east-1"
# 
#}


provider "aws" {
  region              = "us-east-1"
}

variable "availability-zones" {
  type = list(string)
  default = [
     "us-east-1a",
    "us-east-1b"
  ]
}

