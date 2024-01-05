locals {
  service-name       = "ibkr-client-portal-api"
  log-retention-days = 30
  region             = "us-west-2"
  tags = {
    TerraformManaged = "True"
    Project          = "ibkr-client-portal-api"
  }
  secrets = {
    dev = [
      # {
      #   "name" : "IBEAM_ACCOUNT",
      #   "valueFrom" : "arn:aws:secretsmanager:us-west-2:445123149871:secret:dev/ibkr-client-portal-api/ibkr-creds-0zx82G:username::"
      # },
      # {
      #   "name" : "IBEAM_PASSWORD",
      #   "valueFrom" : "arn:aws:secretsmanager:us-west-2:445123149871:secret:dev/ibkr-client-portal-api/ibkr-creds-0zx82G:password::"
      # }
    ]
    prod = [
      # {
      #   "name" : "IBEAM_ACCOUNT",
      #   "valueFrom" : "arn:aws:secretsmanager:us-west-2:445123149871:secret:prod/ibkr-client-portal-api/ibkr-creds-Q4MdRp:username::"
      # },
      # {
      #   "name" : "IBEAM_PASSWORD",
      #   "valueFrom" : "arn:aws:secretsmanager:us-west-2:445123149871:secret:prod/ibkr-client-portal-api/ibkr-creds-Q4MdRp:password::"
      # }
    ]
  }
}
