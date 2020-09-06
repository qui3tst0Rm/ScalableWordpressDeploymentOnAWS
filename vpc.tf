##############################################
##           Provider and Region            ##
##############################################

provider "aws" {
  region = var.region
}

##############################################
##      Virtual Private Cloud (VPC)         ##
##############################################

resource "aws_vpc" "wordpress_site" {
  cidr_block           = var.vpc-cidr
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name

  }
}

