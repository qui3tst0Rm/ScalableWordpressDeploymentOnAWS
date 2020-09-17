######################################################################################
##        Create 3 nat instance that will be placed in the 3 public subnets         ##
######################################################################################
resource "aws_instance" "mynat" {
  ami                    = data.aws_ami.nat_instance.id
  count                  = length(var.nat_instance_names)
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = local.pub_snet_ids[count.index]
  vpc_security_group_ids = [aws_security_group.nat_instance_sec_grp.id]
  source_dest_check      = false


  tags = {
    Name = var.nat_instance_names[count.index]
  }

}

