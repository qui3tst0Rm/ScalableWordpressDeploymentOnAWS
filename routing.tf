#################################################################################
##              Public Route Tables and Route Table Association                ##
#################################################################################
# 1 public route table
resource "aws_route_table" "dmz_rtb" {
  vpc_id = aws_vpc.wordpress_site.id

  tags = {
    Name = var.pub-rtb-name[terraform.workspace]
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

# Will create 3 route table association resources that will associate public subnets to the dmz rtb.
resource "aws_route_table_association" "dmz_rtb_asso" {
  count          = length(var.pub-snet-names)
  subnet_id      = element(aws_subnet.public-snet[*].id, count.index) #local.pub_snet_ids[count.index]
  route_table_id = aws_route_table.dmz_rtb.id
}

#################################################################################
##              Private Route Tables and Route Table Association                ##
#################################################################################

# 3 private route tables
resource "aws_route_table" "pri_rtb" {
  vpc_id = aws_vpc.wordpress_site.id
  count  = length(var.pri-rtb-names)

  tags = {
    Name = var.pri-rtb-names[terraform.workspace][count.index]
  }

  route {
    cidr_block  = "0.0.0.0/0"
    instance_id = element(aws_instance.mynat[*].id, count.index)
  }

  /*route {
    cidr_block  = "172.28.0.0/16"
    vpc_peering_connection_id = "pcx-07d3adbbb7da85c24"
  }*/

}

resource "aws_route_table_association" "private_rtbs_asso" {
  count          = length(aws_subnet.private-snet[*].id)
  subnet_id      = element(aws_subnet.private-snet[*].id, count.index)
  route_table_id = element(aws_route_table.pri_rtb[*].id, count.index)


}