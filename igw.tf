##############################################
##              Internet Gateway            ##
##############################################

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.wordpress_site.id
  tags = {
    Name = var.igw-name[terraform.workspace]
  }
}























