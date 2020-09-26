#################################################################
#                Auto Scaling Group for Wordpress               #  
#################################################################

resource "aws_autoscaling_group" "wordpress_asg" {
  name                 = "wordpress asg"
  launch_configuration = aws_launch_configuration.webserver_launch_config.name
  min_size             = var.inst-asg.min-size
  max_size             = var.inst-asg.max-size
  desired_capacity     = var.inst-asg.desired-capacity
  vpc_zone_identifier  = [aws_subnet.private-snet[0].id, aws_subnet.private-snet[1].id, aws_subnet.private-snet[2].id]
  #vpc_zone_identifier  = aws_subnet.private-snet[count.index % var.subnet_count].id
  target_group_arns = [aws_lb_target_group.wordpress_tg.arn]

  lifecycle {
    create_before_destroy = true
  }

}

#################################################################
#                      MYSQL DB Instance                        #  
#################################################################

resource "aws_db_instance" "wordpress_db" {
  allocated_storage = var.mysql.allocated_storage
  storage_type      = var.mysql.storage_type
  engine            = var.mysql.engine
  engine_version    = var.mysql.engine_version
  instance_class    = var.mysql.instance_class
  # need a better way to manage the master db username and password  
  name     = var.creds_dbname
  username = var.creds_dbusername
  password = var.creds_dbpassword

  #username               = local.wp-db-creds.username
  #password               = local.wp-db-creds.password

  skip_final_snapshot    = true
  parameter_group_name   = var.mysql.parameter_group_name
  vpc_security_group_ids = [aws_security_group.database_sec_grp.id]
  db_subnet_group_name   = aws_db_subnet_group.pri_db_snet_grp.name
}