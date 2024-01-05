resource "aws_ecs_service" "ibkr-client-portal-api" {
  name            = local.service-name
  cluster         = data.terraform_remote_state.infra-core.outputs.ecs.clusters[terraform.workspace].arn
  task_definition = aws_ecs_task_definition.ibkr-client-portal-api.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    assign_public_ip = false

    security_groups = [
      data.terraform_remote_state.infra-core.outputs.security-group.egress-all.id,
      data.terraform_remote_state.infra-core.outputs.security-group.ingress-ephemeral.id,
    ]

    subnets = [
      data.terraform_remote_state.infra-core.outputs.subnet.private.us-west-2a.id,
      data.terraform_remote_state.infra-core.outputs.subnet.private.us-west-2b.id,
      data.terraform_remote_state.infra-core.outputs.subnet.private.us-west-2c.id,
      data.terraform_remote_state.infra-core.outputs.subnet.private.us-west-2d.id,
    ]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ibkr-client-portal-api-tg-5000.arn
    container_name   = "${local.service-name}-server"
    container_port   = 5000
  }

  tags = local.tags
}

