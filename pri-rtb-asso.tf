resource "aws_route_table_association" "private_rtbs_asso" {
  count          = length(var.private-subnet-names)
  subnet_id      = local.pri_snet_ids[count.index]
  route_table_id = local.private_rtb_ids[count.index]
  #route_table_id = local.nat_inst_ids[count.index]

}