#################################################################
#           Wordpress Launch Config & Auto Scaling              #  
#################################################################
resource "aws_launch_configuration" "webserver_launch_config" {
  name_prefix     = "wordpress-launch-config-"
  image_id        = data.aws_ami.wordpress_packer_image.id
  instance_type   = var.instance_type
  key_name        = var.key_name
  security_groups = [aws_security_group.webserver_sec_grp.id]
  user_data       = data.template_file.install_wp.rendered

  lifecycle {
    create_before_destroy = true
  }


}

resource "aws_autoscaling_group" "wordpress_asg" {
  name                 = "wordpress asg"
  launch_configuration = aws_launch_configuration.webserver_launch_config.name
  min_size             = 3
  max_size             = 6
  desired_capacity     = 3
  vpc_zone_identifier  = [aws_subnet.private-snet[0].id, aws_subnet.private-snet[1].id, aws_subnet.private-snet[2].id]

  lifecycle {
    create_before_destroy = true
  }

  # Inappropriate value for attribute "tags": set of map of string required.


}



resource "aws_db_instance" "wordpress_db" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  name                   = "wpdbname"
  username               = "wordpress"
  password               = "X1qaz2wsxX123456X"
  skip_final_snapshot    = true
  parameter_group_name   = "default.mysql5.7"
  vpc_security_group_ids = local.db_sec_group
  db_subnet_group_name   = aws_db_subnet_group.pri_db_snet_grp.name
}



