This terraform project comprises 2 files: 
    00. variables.tf and 
    01. terraform-FTGT-AutoScale.tf

The main script is "01. terraform-FTGT-AutoScale.tf"

It deploys Fortigates as part of an AutoScale group behind a Network Load Balancer on AWS using the CloudFormation templates found in Rls 1.0.6 found on the projects page of the Fortinet Github site: https://github.com/fortinet/fortigate-autoscale/releases 
Deployment uses the Pay As You Go (PAYG) model 

The script automates the instructions for "Deploying auto scaling on AWS without Transit Gateway integration" found on the following Fortinet Docs location: https://docs.fortinet.com/vm/aws/fortigate/6.2/aws-cookbook/6.2.0/543390/deploying-auto-scaling-on-aws-without-transit-gateway-integration 

Uses the CloudFormation template "Deployment into a new VPC (end-to-end deployment)". This option builds a new AWS environment consisting of the VPC, subnets, FortiGate-VMs, security groups, and other infrastructure components, and then deploys FortiGate Autoscale for AWS into this new VPC.

The default parameters are applied when creating the VPC resources (See at the end of this README.md). 
Some parameters need to be specified - see file 00. variables.tf

The script assumes the prerequisites of the above doc have been met:
- Need to have a valid Key Pair in the AWS region used
- Need to have copied the CloudFormation templates etc into S3 bucket in the same AWS region, this bucket should be made public
- Need to have an ongoing subscription to FortiGate on-demand (PAYG) in AWS Marketplace

Default parameters:
They concern mainly the VPC settings and can be found in the template: fortigate-autoscale-aws-cloudformation/templates/workload-master.template.

"fortigate-autoscale-aws-cloudformation" is in the zip folder that can be downloaded from: https://github.com/fortinet/fortigate-autoscale/releases

Here are the default values of the parameters:

-         "VPCCIDR": {
            "Type": "String",
            "Default": "10.0.0.0/16",
            "AllowedPattern": "^(([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5]){1}(\\/([0-9]|[1-2][0-9]|3[0-2]))?$",
            "ConstraintDescription": "must be a valid CIDR block format.",
            "Description": "The CIDR block for the VPC."
        },
-         "PublicSubnet1CIDR": {
            "Type": "String",
            "Default": "10.0.0.0/24",
            "AllowedPattern": "^(([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5]){1}(\\/([0-9]|[1-2][0-9]|3[0-2]))?$",
            "ConstraintDescription": "must be a valid CIDR block format.",
            "Description": "The CIDR block for the public (DMZ) subnet located in Availability Zone 1."
        },
-         "PublicSubnet2CIDR": {
            "Type": "String",
            "Default": "10.0.2.0/24",
            "AllowedPattern": "^(([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5]){1}(\\/([0-9]|[1-2][0-9]|3[0-2]))?$",
            "ConstraintDescription": "must be a valid CIDR block format.",
            "Description": "The CIDR block for the public (DMZ) subnet located in Availability Zone 2."
        },
-         "PrivateSubnet1CIDR": {
            "Type": "String",
            "Default": "10.0.1.0/24",
            "AllowedPattern": "^(([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5]){1}(\\/([0-9]|[1-2][0-9]|3[0-2]))?$",
            "ConstraintDescription": "must be a valid CIDR block format.",
            "Description": "The CIDR block for the private subnet located in Availability Zone 1."
        },
-         "PrivateSubnet2CIDR": {
            "Type": "String",
            "Default": "10.0.3.0/24",
            "AllowedPattern": "^(([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5]){1}(\\/([0-9]|[1-2][0-9]|3[0-2]))?$",
            "ConstraintDescription": "must be a valid CIDR block format.",
            "Description": "The CIDR block for the private subnet located in Availability Zone 2."
        },
-         "FortiGateInstanceType": {
            "Type": "String",
            "Default": "c5.large",
            "AllowedValues": [
                "t2.small",
                "c5.large",
                "c5.xlarge",
                "c5.2xlarge",
                "c5.4xlarge",
                "c5.9xlarge"
            ],
            "ConstraintDescription": "must be a valid EC2 instance type.",
            "Description": "Instance type to launch as FortiGate On-Demand instances. There are t2.small and compute-optimized instances such as c4 and c5 available with different vCPU sizes and bandwidths. For more information about instance types, see https://aws.amazon.com/ec2/instance-types/"
        },
-         "FortiOSVersion": {
            "Type": "String",
            "Default": "Latest (6.2.1)",
            "AllowedValues": [
                "Latest (6.2.1)",
                "FortiOS 6.2.1",
                "FortiOS 6.0.6"
            ],
            "ConstraintDescription": "must be a valid FortiOS version from the selection.",
            "Description": "FortiOS versions."
        },
-        "ExpireLifecycleEntry": {
            "Type": "Number",
            "Default": 400,
            "MinValue": 60,
            "MaxValue": 3600,
            "ConstraintDescription": "must be a valid number between 60 and 3600.",
            "Description": "FortiGate instance lifecycle expiry entry (in seconds). Minimum is 60. Maximum is 3600."
        },
-         "FortiGateAsgCooldown": {
            "Type": "Number",
            "Default": 300,
            "MinValue": 60,
            "MaxValue": 3600,
            "ConstraintDescription": "must be a valid number between 60 and 3600.",
            "Description": "Auto Scaling group waits for the cooldown period (in seconds) to complete before resuming scaling activities. Minimum is 60. Maximum is 3600."
        },
-         "FortiGateAsgDesiredCapacity": {
            "Type": "Number",
            "Default": 2,
            "MinValue": 2,
            "ConstraintDescription": "must be a valid number not less than 2.",
            "Description": "The number of FortiGate instances the group should have at any time, also called desired capacity. Must keep at least 2 FortiGates in the group for High Availability. Minimum is 2."
        },
-         "FortiGateAsgMinSize": {
            "Type": "Number",
            "Default": 2,
            "MinValue": 2,
            "ConstraintDescription": "must be a valid number not less than 2.",
            "Description": "Minimum number of FortiGate instances in the Auto Scaling Group. Minimum is 2."
        },
-         "FortiGateAsgMaxSize": {
            "Type": "Number",
            "Default": 4,
            "MinValue": 2,
            "ConstraintDescription": "must be a valid number not less than 2.",
            "Description": "Maximum number of FortiGate instances in the Auto Scaling Group. Minimum is 2."
        },
-         "FortiGateAsgHealthCheckGracePeriod": {
            "Type": "Number",
            "Default": 300,
            "MinValue": 60,
            "ConstraintDescription": "must be a valid number not less than 60.",
            "Description": "The length of time (in seconds) that Auto Scaling waits before checking an instance's health status. Minimum is 60."
        },
-         "FortiGateAsgScaleInThreshold": {
            "Type": "Number",
            "Default": 25,
            "MinValue": 1,
            "MaxValue": 100,
            "ConstraintDescription": "must be a valid number between 1 and 100.",
            "Description": "The threshold (in percentage) for the FortiGate Auto Scaling group to scale-in (remove) 1 instance. Minimum is 1. Maximum is 100."
        },
-         "FortiGateAsgScaleOutThreshold": {
            "Type": "Number",
            "Default": 80,
            "MinValue": 1,
            "MaxValue": 100,
            "ConstraintDescription": "must be a valid number between 1 and 100.",
            "Description": "The threshold (in percentage) for the FortiGate Auto Scaling group to scale-out (add) 1 instance. Minimum is 1. Maximum is 100."
        },
-         "FortiGateElbTgHealthyThreshold": {
            "Type": "Number",
            "Default": 3,
            "MinValue": 3,
            "ConstraintDescription": "must be a valid number not less than 3.",
            "Description": "The number of consecutive health check failures required before considering a FortiGate instance unhealthy. Minimum is 3."
        },
-         "BalanceWebTrafficOverPort": {
            "Type": "Number",
            "Default": 443,
            "MinValue": 1,
            "MaxValue": 65535,
            "ConstraintDescription": "must be a valid port number between 1 and 65535.",
            "Description": "Balance web service traffic over this port if the internal web-service load balancer is enabled. Minimum is 1. Maximum is 65535."
        },
-         "InternalLoadBalancingOptions": {
            "Type": "String",
            "Default": "add a new internal load balancer",
            "AllowedValues": [
                "add a new internal load balancer",
                "use an existing load balancer",
                "do not need one"
            ],
            "ConstraintDescription": "must choose from the provided options.",
            "Description": "Options for add an optional pre-defined load balancer to route traffic to web service in the private subnets. You can optionally use your own one or decide to not need one."
        },
-         "InternalLoadBalancerDnsName": {
            "Type": "String",
            "Description": "(Optional)DNS Name of the Elastic Load Balancer which is used in the private subnets. Specify if only you use your own one."
        },
        "FortiGatePskSecret": {
            "Type": "String",
            "NoEcho": true,
            "MaxLength": "128",
            "Description": "A secret key for the FortiGate instances to securely communicate with each other. It can be of your choice of a string, such as numbers or letters or the combination of them. Max length 128."
        },
-         "FortiGateAdminPort": {
            "Type": "Number",
            "Default": 8443,
            "MinValue": 1,
            "MaxValue": 65535,
            "ConstraintDescription": "must be a valid port number between 1 and 65535.",
            "Description": "A port number for FortiGate administration. Minimum is 1. Maximum is 65535. Do not use: 443, 541, 514, 703 because these are FortiGate reserved ports."
        },
-         "FortiGateAdminCidr": {
            "Type": "String",
            "AllowedPattern": "^(([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5]){1}(\\/([0-9]|[1-2][0-9]|3[0-2]))?$",
            "ConstraintDescription": "must be a valid CIDR block format and 0.0.0.0/0 is highly not recommended.",
            "Description": "CIDR block for external admin management access. **WARNING!** 0.0.0.0/0 accepts connections from any IP address. We recommend that you use a constrained CIDR range to reduce the potential of inbound attacks from unknown IP addresses."
        },
-         "KeyPairName": {
            "Type": "AWS::EC2::KeyPair::KeyName",
            "ConstraintDescription": "must specify an admin access key pair for FortiGate instances.",
            "Description": "Amazon EC2 Key Pair for admin access."
        },
-         "HeartBeatLossCount": {
            "Type": "Number",
            "Default": 3,
            "MinValue": 1,
            "MaxValue": 65535,
            "ConstraintDescription": "must be a valid number between 1 and 65535.",
            "Description": "Number of consecutively lost heartbeats. When the Heartbeat Loss Count has been reached, the VM is deemed unhealthy and fail-over activities will commence."