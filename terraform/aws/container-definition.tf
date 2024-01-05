# https://registry.terraform.io/modules/cloudposse/ecs-container-definition/aws/
module "server-container-definition" {
  source  = "cloudposse/ecs-container-definition/aws"
  version = "0.60.0"

  command                      = null # default
  container_cpu                = 1024 # 1vCPU
  container_definition         = {}
  container_depends_on         = [] # default
  container_image              = "${data.terraform_remote_state.infra-core.outputs.ecr.ibkr-client-portal-api.repository_url}:${var.image_tag}"
  container_memory             = 2048 # 2GB
  container_memory_reservation = null # default
  container_name               = "${local.service-name}-server"
  disable_networking           = null # default
  dns_search_domains           = []   # default
  dns_servers                  = []   # default
  docker_labels                = null # default
  docker_security_options      = []   # default
  entrypoint                   = null # default
  environment                  = []   # default
  environment_files            = []   # default
  essential                    = true # default
  extra_hosts                  = []   # default
  firelens_configuration       = null
  healthcheck                  = null # default
  hostname                     = null # default
  interactive                  = null # default
  log_configuration = {
    logDriver = "awslogs",
    options = {
      awslogs-region        = local.region,
      awslogs-stream-prefix = "server"
      awslogs-group         = aws_cloudwatch_log_group.ibkr-client-portal-api.name
    }
  }
  links            = []   # default
  linux_parameters = null # default

  map_environment = {
    "DOCKER_TAG" : var.image_tag,
    "OPTICA_ENV" : terraform.workspace,
    "IBEAM_REQUEST_RETRIES" : "5",
    # Ref: https://github.com/Voyz/ibeam/issues/152#issuecomment-1804518318
    "IBEAM_MAX_STATUS_CHECK_RETRIES" : "15"
  }
  mount_points = [] # default
  port_mappings = [
    { "containerPort" : 5000, "hostPort" : 5000, "protocol" : "tcp" },
    { "containerPort" : 5001, "hostPort" : 5001, "protocol" : "tcp" },
  ]
  privileged               = null  # default
  pseudo_terminal          = null  # default
  readonly_root_filesystem = false # default
  repository_credentials   = null  # default

  secrets           = local.secrets["${terraform.workspace}"]
  start_timeout     = null # default
  stop_timeout      = null # default
  system_controls   = []   # default
  ulimits           = []   # default
  user              = null # default
  volumes_from      = []   # default
  working_directory = null # default
}
