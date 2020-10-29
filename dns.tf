data "aws_route53_zone" "selected" {
  name = var.dns_zone_name
}
resource "aws_route53_record" "dns_wordpress" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name = "wordpress1.${data.aws_route53_zone.selected.name}"
  type = "A"
  alias {
    name                   = aws_elb.web.dns_name
    zone_id                = aws_elb.web.zone_id
    evaluate_target_health = true
  }
  provider = aws.account_route53
}