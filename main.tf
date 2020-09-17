#################################################################
#                Auto Scaling Group for Wordpress               #  
#################################################################

resource "aws_autoscaling_group" "wordpress_asg" {
  name                 = "wordpress asg"
  launch_configuration = aws_launch_configuration.webserver_launch_config.name
  min_size             = var.asg-min-size
  max_size             = var.asg-max-size
  desired_capacity     = var.desired-capacity
  vpc_zone_identifier  = [aws_subnet.private-snet[0].id, aws_subnet.private-snet[1].id, aws_subnet.private-snet[2].id]
  #target_group_arns = [aws_lb_target_group.wordpress_tg.arn]

  lifecycle {
    create_before_destroy = true
  }

}

#################################################################
#                      MYSQL DB Instance                        #  
#################################################################

resource "aws_db_instance" "wordpress_db" {
  allocated_storage = var.allocated_storage
  storage_type      = var.storage_type
  engine            = var.engine
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  name              = var.db-name
  username          = var.db-username
  password          = var.db-password
  #username               = local.wp-db-creds.username
  #password               = local.wp-db-creds.password

  skip_final_snapshot    = true
  parameter_group_name   = "default.mysql5.7"
  vpc_security_group_ids = local.db_sec_group
  db_subnet_group_name   = aws_db_subnet_group.pri_db_snet_grp.name
}

# need a better way to manage the master db username and password







