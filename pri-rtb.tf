# 3 private route tables
resource "aws_route_table" "pri_rtb" {
  vpc_id = aws_vpc.wordpress_site.id
  count  = length(var.private-rtb-names)

  tags = {
    Name = var.private-rtb-names[count.index]
  }

  route {
    cidr_block  = "0.0.0.0/0"
    instance_id = local.nat_inst_ids[count.index]
  }

  /*route {
    cidr_block  = "172.28.0.0/16"
    vpc_peering_connection_id = aws_vpc_peering_connection.prometheusVPC_to_wordpressVPC.id
  }*/

}