######################################################################################
##        Create 3 nat instance that will be placed in the 3 public subnets         ##
######################################################################################
resource "aws_instance" "mynat" {
  ami                    = data.aws_ami.nat_instance.id
  count                  = length(var.nat-instance-names)
  instance_type          = var.instance_size[terraform.workspace]
  key_name               = var.key_name
  subnet_id              = element(aws_subnet.public-snet[*].id, count.index)
  vpc_security_group_ids = [aws_security_group.nat_instance_sec_grp.id]
  source_dest_check      = false


  tags = {
    Name = var.nat-instance-names[count.index]
  }

}

