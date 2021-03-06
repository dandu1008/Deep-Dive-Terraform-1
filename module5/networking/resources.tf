##################################################################################
# PROVIDERS
##################################################################################

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-west-2"
}

##################################################################################
# DATA
##################################################################################

data "aws_availability_zones" "available" {}

##################################################################################
# RESOURCES
##################################################################################

# NETWORKING #
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name   = "ddt-${terraform.workspace}"
  version = "1.66.0"
  cidr            = "${data.external.configuration.result.vpc_cidr_range}"
  azs             = "${slice(data.aws_availability_zones.available.names,0,data.external.configuration.result.vpc_subnet_count)}"
  private_subnets = "${data.template_file.private_cidrsubnet.*.rendered}"
  public_subnets  = "${data.template_file.public_cidrsubnet.*.rendered}"

  enable_nat_gateway = true

  create_database_subnet_group = false

  tags = "${local.common_tags}"
}
