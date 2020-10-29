resource "aws_autoscaling_group" "web" {
  name                 = "ASG-${aws_launch_configuration.web.name}"
  launch_configuration = aws_launch_configuration.web.name
  min_size             = 2
  max_size             = 4
  desired_capacity     = 2
  health_check_type    = "ELB"
  vpc_zone_identifier  = [aws_subnet.private.0.id, aws_subnet.private.1.id]
  load_balancers       = [aws_elb.web.id]

  enabled_metrics = [
      "GroupMinSize",
      "GroupMaxSize",
      "GroupDesiredCapacity",
      "GroupInServiceInstances",
      "GroupTotalInstances"
  ]
  metrics_granularity="1Minute"
  
  dynamic "tag" {
    for_each = {
      Name   = "WebServer in ASG"
      owner = var.owner
      TAGKEY = "TAGVALUE"
    }
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}
