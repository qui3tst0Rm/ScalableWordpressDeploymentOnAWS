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
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    #cidr_blocks = ["0.0.0.0/0"]
    security_groups = [aws_security_group.alb_sec_grp.id]
  }
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
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