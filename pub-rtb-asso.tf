##############################################
##        Route Tables Association          ##
##############################################

# Will create 3 route table association resources that will associate public subnets to the dmz rtb.
resource "aws_route_table_association" "dmz_rtb_asso" {
  count          = length(var.public-subnet-names)
  subnet_id      = local.pub_snet_ids[count.index]
  route_table_id = aws_route_table.dmz_rtb.id
}