resource "aws_ecs_task_definition" "ibkr-client-portal-api" {
  family             = "${terraform.workspace}-${local.service-name}"
  execution_role_arn = aws_iam_role.ibkr-client-portal-api.arn
  task_role_arn      = aws_iam_role.ibkr-client-portal-api.arn

  container_definitions = jsonencode([
    module.server-container-definition.json_map_object,
  ])

  cpu                      = 1024
  memory                   = 2048
  requires_compatibilities = ["FARGATE"]

  # This is required for Fargate containers
  network_mode = "awsvpc"
}
