#################################################################
#                    Launch Config for ASG                      #  
#################################################################
resource "aws_launch_configuration" "webserver_launch_config" {
  name_prefix     = "wordpress-launch-config-"
  image_id        = data.aws_ami.wordpress_packer_image.id
  instance_type   = var.instance_size[terraform.workspace]
  key_name        = var.key_name
  security_groups = [aws_security_group.webserver_sec_grp.id]
  user_data       = data.template_file.install_wp.rendered

  lifecycle {
    create_before_destroy = true
  }


}