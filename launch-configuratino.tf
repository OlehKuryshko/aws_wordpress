resource "aws_launch_configuration" "web" {
  name            = "WebServer-wordpress-LH"
  image_id        = var.ami_wordpress
  instance_type   = var.instance_type
  security_groups = [aws_security_group.web.id, aws_security_group.allow_ssh.id]
  user_data       = file("user_data.sh")
  key_name = var.key_name
  lifecycle {
    create_before_destroy = true
  }
}