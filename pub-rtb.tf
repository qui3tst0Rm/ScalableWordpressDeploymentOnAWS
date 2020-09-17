##############################################
##              Route Tables                ##
##############################################
# 1 public route table
resource "aws_route_table" "dmz_rtb" {
  vpc_id = aws_vpc.wordpress_site.id

  tags = {
    Name = var.public-rtb-names
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}