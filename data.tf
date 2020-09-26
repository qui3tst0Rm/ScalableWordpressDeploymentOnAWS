# Packer ami for provisioning wordpress webserver
data "aws_ami" "wordpress_packer_image" {
  most_recent = true
  filter {
    name   = "name"
    values = ["wordpress-php7-node_exporter-packer-ami"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["self"]
}

# community ami for provisioning nat instance
data "aws_ami" "nat_instance" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-vpc-nat-hvm-2018.03.0.20181116-x86_64-ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["amazon"]
}

#
data "template_file" "install_wp" {
  template = file("init.tpl")

  vars = {
    #mysql_endpoint = aws_db_instance.wordpress_db.endpoint
    mysql_address = aws_db_instance.wordpress_db.address
  }
}

# to manage secerets wp db credentials
/*data "aws_secretsmanager_secret_version" "creds" {
  secret_id = "wp-db-creds"

}*/

####
data "template_file" "cidrsubnet" {
  count = var.total_subnet_count[terraform.workspace]

  template = "$${cidrsubnet(vpc-cidr-block,3,current_count)}"

  vars = {
    vpc-cidr-block = var.vpc-cidr-block[terraform.workspace]
    current_count  = count.index
  }
}

