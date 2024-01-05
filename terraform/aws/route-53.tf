resource "aws_route53_record" "endpoint-record" {
  zone_id = data.terraform_remote_state.infra-core.outputs.dns.route-53-zone-id
  name    = "${local.service-name}.${terraform.workspace}.optica.xyz"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_alb.ibkr-client-portal-api.dns_name]
}
