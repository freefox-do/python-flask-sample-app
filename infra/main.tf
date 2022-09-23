terraform {
  backend "s3" {
    profile  = "aws-devops"
    bucket   = "terraform-state-file-devops"
    region   = "ap-southeast-2"
    key      = "aws/cloudwatch/custom-metrics-alarms/terraform.tfstate"
  }
}
