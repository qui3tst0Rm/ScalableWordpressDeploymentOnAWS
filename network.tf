##############################################
##              Internet Gateway            ##
##############################################

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.wordpress_site.id
  tags = {
    Name = "vpc-test-igw"
  }
}

##############################################
##       Network Access Control List        ##
##############################################



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



##############################################
##        Route Tables Association          ##
##############################################

# Will create 3 route table association resources that will associate public subnets to the dmz rtb.
resource "aws_route_table_association" "dmz_rtb_asso" {
  count          = length(var.public-subnet-names)
  subnet_id      = local.pub_snet_ids[count.index]
  route_table_id = aws_route_table.dmz_rtb.id
}

resource "aws_route_table_association" "private_rtbs_asso" {
  count          = length(var.private-subnet-names)
  subnet_id      = local.pri_snet_ids[count.index]
  route_table_id = local.private_rtb_ids[count.index]
  #route_table_id = local.nat_inst_ids[count.index]

}

##############################################
##              Route Tables                ##
##############################################
# 1 public route table
resource "aws_route_table" "dmz_rtb" {
  vpc_id = aws_vpc.wordpress_site.id

  tags = {
    Name = "dmz_rtb"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

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

}




##################################################################################
##                            SECURITY GROUPS                                   ##
##################################################################################

#####################################
#####     dmz security group    #####
#####################################

resource "aws_security_group" "alb_sec_grp" {
  name        = "alb-sec-group"
  description = "sec group for alb"
  vpc_id      = aws_vpc.wordpress_site.id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  /*ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }*/

  /*ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }*/
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

######################################
##### Sec group for nat instance #####
######################################

resource "aws_security_group" "nat_instance_sec_grp" {
  name        = "nat-instance-sec-grp"
  description = "sec group for nat instance"
  vpc_id      = aws_vpc.wordpress_site.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    #security_groups = [aws_security_group.webserver-sec-grp.id]
    # might need to allow inbound access from db , "DB-Instance-sec-gp"
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.webserver_sec_grp.id]
    #cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  # depends_on = [aws_security_group.webserver-sec-grp.id]
}


#####################################
##### Sec group for web servers #####
#####################################

resource "aws_security_group" "webserver_sec_grp" {
  name        = "webserver-sec-group"
  description = "sec group for webserver"
  vpc_id      = aws_vpc.wordpress_site.id

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sec_grp.id]
    #cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sec_grp.id]
    #cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    #cidr_blocks = ["0.0.0.0/0"]
    security_groups = [aws_security_group.alb_sec_grp.id]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    #cidr_blocks = ["0.0.0.0/0"]
    security_groups = [aws_security_group.alb_sec_grp.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#####################################
#####  Sec group for Database   #####
#####################################

resource "aws_security_group" "database_sec_grp" {
  name        = "Mysql database security group"
  description = "sec group for the database"
  vpc_id      = aws_vpc.wordpress_site.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.webserver_sec_grp.id]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.webserver_sec_grp.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

########################################
#####  Application Load Balancer   #####
########################################

# Create an application LB resource
resource "aws_lb" "wordpress_alb" {
  name               = "AppLoadBalancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = local.alb_sec_group
  subnets            = local.pub_snet_ids


  tags = {
    Name = var.lb_name
  }

}

# Create a target group resource for use with LB resource
resource "aws_lb_target_group" "wordpress_tg" {
  name        = "lb-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.wordpress_site.id
  target_type = "instance"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 6
    path                = var.health_check_path
    protocol            = "HTTP"
    port                = 80
    matcher             = 200
  }
}

/*resource "aws_lb_target_group" "wordpress_tg1" {
  name        = "lb-target-group9100"
  port        = 9100
  protocol    = "HTTP"
  vpc_id      = aws_vpc.wordpress_site.id
  target_type = "instance"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 6
    path                = var.health_check_path9100
    protocol            = "HTTP"
    port                = 9100
    matcher             = 200
  }
}*/

resource "aws_lb_listener" "wordpress_tg_list" {
  load_balancer_arn = aws_lb.wordpress_alb.arn
  port              = "80"
  protocol          = "HTTP"
  #ssl_policy        = "ELBSecurityPolicy-2016-08"
  #certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress_tg.arn
  }
}

/*resource "aws_lb_listener" "wordpress_tg_list9100" {
  load_balancer_arn = aws_lb.wordpress_alb.arn
  port              = "9100"
  protocol          = "HTTP"
  #ssl_policy        = "ELBSecurityPolicy-2016-08"
  #certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress_tg.arn
  }
}*/

# Create target group attachment

/*resource "aws_lb_target_group_attachment" "wordpress_tga" {
  target_group_arn = aws_lb_target_group.wordpress_tg.arn
  target_id        = aws_lb_target_group.wordpress_tg.id
  #target_id        = aws_instance.wordpress_web.id
  port = 80

}*/
# Create a new ALB Target Group attachment
resource "aws_autoscaling_attachment" "wordpress_asga" {
  autoscaling_group_name = aws_autoscaling_group.wordpress_asg.id
  alb_target_group_arn   = aws_lb_target_group.wordpress_tg.arn


}


