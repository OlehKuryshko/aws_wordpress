resource "aws_elb" "web" {
  name               = "WebServer-HA-ELB"
  security_groups = [aws_security_group.ssl.id]
  # security_groups = [aws_security_group.ssl.id, aws_security_group.web.id]
  subnets = aws_subnet.public.*.id
  cross_zone_load_balancing = true
  # listener {
  #   lb_port           = 80
  #   lb_protocol       = "http"
  #   instance_port     = 80
  #   instance_protocol = "http"
  # }
  listener {
    instance_port      = 80
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = var.ssl_certificate
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/wp-admin/install.php"
    interval            = 20
  }
  tags = {
    Name = "WebServer-Highly-Available-ELB"
    owner = var.owner
  }
}