########################################
#####  Application Load Balancer   #####
########################################

# Create an application LB resource
resource "aws_lb" "wordpress_alb" {
  name               = "AppLoadBalancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sec_grp.id]
  subnets            = aws_subnet.public-snet[*].id


  tags = {
    Name = var.lb-name[terraform.workspace]
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