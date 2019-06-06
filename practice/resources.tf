provider "aws" {
    aws_access_key = "${var.aws_access_key}"
    aws_secret_key = "${var.aws_secret_key}"
    region = "eu-west-1"
}

data "aws_availability_zones" "available" {} 

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "Terraform"
  cidr = "10.0.0.0/16"

  azs             = "${slice(data.aws_availability_zones.available.names,0,var.subnet_count)}"
  private_subnets = ["10.0.1.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.0.0/24", "10.0.2.0/24"]

  enable_nat_gateway = true
  //enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}
