resource "aws_cloudwatch_log_group" "ibkr-client-portal-api" {
  name              = "${terraform.workspace}-${local.service-name}"
  retention_in_days = local.log-retention-days
  tags              = local.tags
}
