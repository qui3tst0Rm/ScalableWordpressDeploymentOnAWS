locals {
  webserver_sec_group = concat([aws_security_group.webserver_sec_grp.id])
}

locals {
  db_sec_group = concat([aws_security_group.database_sec_grp.id])
}

locals {
  alb_sec_group = concat([aws_security_group.alb_sec_grp.id])
}

locals {
  nat_sec_group = concat([aws_security_group.nat_instance_sec_grp.id])
}

locals {
  pub_snet_ids = concat([aws_subnet.public-snet[0].id], [aws_subnet.public-snet[1].id], [aws_subnet.public-snet[2].id])
}

locals {
  nat_inst_ids = concat([aws_instance.mynat[0].id], [aws_instance.mynat[1].id], [aws_instance.mynat[2].id])
}

locals {
  pri_snet_ids = concat([aws_subnet.private-snet[0].id], [aws_subnet.private-snet[1].id], [aws_subnet.private-snet[2].id])
}

# Public subnet names
locals {
  pub-snet-names = concat(["pub-snet-1-eu-west-2a"], ["pub-snet-2-eu-west-2b"], ["pub-snet-3-eu-west-2c"])
}

# Private subnet names
locals {
  pri-snet-names = concat(["pri-snet-1-eu-west-2a"], ["pri-snet-2-eu-west-2b"], ["pri-snet-3-eu-west-2c"])
}

# Private rtb ids
locals {
  private_rtb_ids = concat([aws_route_table.pri_rtb[0].id], [aws_route_table.pri_rtb[1].id], [aws_route_table.pri_rtb[2].id])
}

# Nat instance names
locals {
  nat-instances-names = concat(["nat1-pub-snet-1-eu-west-2a", "nat2-pub-snet-2-eu-west-2b", "nat3-pub-snet-3-eu-west-2c"])
}

# az's
locals {
  az = concat(["eu-west-2a", "eu-west-2b", "eu-west-2c"])
}

# wordpress db credentials
/*locals {
  wp-db-creds = jsondecode(
    data.aws_secretsmanager_secret_version.creds.secret_string
  )
}*/


