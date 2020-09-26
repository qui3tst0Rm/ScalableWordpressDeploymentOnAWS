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
  cidr_block           = var.vpc-cidr-block[terraform.workspace]
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc-name[terraform.workspace]

  }
}

