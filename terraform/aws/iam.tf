# Create the execution role for the ECS task
resource "aws_iam_role" "ibkr-client-portal-api-role" {
  name = "${terraform.workspace}-${local.service-name}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ecs-tasks.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      },
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "events.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
  tags = {
    terraform = "true"
  }
}

# Import managed policy for Running ECS Tasks
data "aws_iam_policy" "AmazonECSTaskExecutionRolePolicy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Attach ECS Task running policy to role
resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-attachment" {
  role       = aws_iam_role.ibkr-client-portal-api-role.name
  policy_arn = data.aws_iam_policy.AmazonECSTaskExecutionRolePolicy.arn
}

# Create a policy for daemon role
resource "aws_iam_policy" "ibkr-client-portal-api-policy" {
  name   = "${terraform.workspace}-${local.service-name}-policy"
  policy = data.aws_iam_policy_document.ibkr-client-portal-api-policies.json
}
data "aws_iam_policy_document" "ibkr-client-portal-api-policies" {
  # Allow service to read secrets
  statement {
    sid = "AllowReadingSecrets"
    actions = [
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds",
    ]
    resources = [
      "arn:aws:secretsmanager:us-west-2:445123149871:secret:shared/*",
      "arn:aws:secretsmanager:us-west-2:445123149871:secret:${terraform.workspace}/${local.service-name}/*",
    ]
  }

  # For cloudwatch logging
  # Ref: https://github.com/maxbanton/cwh#aws-iam-needed-permissions
  statement {
    sid = "AllowCreateLogGroups"
    actions = [
      "logs:CreateLogGroup",
      "logs:DescribeLogGroups"
    ]
    resources = ["*"]
  }
  statement {
    sid = "AllowCreateLogStreamsAndPutLogs"
    actions = [
      "logs:DescribeLogStreams",
      "logs:PutRetentionPolicy",
      "logs:PutLogEvents",
      "logs:CreateLogStream",
    ]
    resources = [
      "${aws_cloudwatch_log_group.ibkr-client-portal-api.arn}:*"
    ]
  }
  statement {
    sid = "AllowGetLogEventsForAllResources"
    actions = [
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:GetLogEvents"
    ]
    resources = ["*"]
  }

  # Datadog
  # statement {
  #   sid = "AllowDatadogReadContainerStats"
  #   actions = [
  #     "ecs:ListClusters",
  #     "ecs:ListContainerInstances",
  #     "ecs:DescribeContainerInstances",
  #   ]
  #   resources = ["*"]
  # }

  # START: Permissions for ECS Exec
  # Ref: https://aws.amazon.com/blogs/containers/new-using-amazon-ecs-exec-access-your-containers-fargate-ec2/
  statement {
    sid = "AllowECSExecDataChannels"
    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel",
    ]
    resources = ["*"]
  }
  statement {
    sid = "AllowECSExecReadLogGroups"
    actions = [
      "logs:DescribeLogGroups"
    ]
    resources = ["*"]
  }
  statement {
    sid = "AllowECSExecWriteLogEvents"
    actions = [
      "logs:CreateLogStream",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents",
      "logs:PutRetentionPolicy"
    ]
    resources = [
      "${aws_cloudwatch_log_group.ibkr-client-portal-api.arn}:*"
    ]
  }
  statement {
    sid = "AllowECSExecWriteSessionLogs"
    actions = [
      "s3:PutObject"
    ]
    resources = [
      # TODO: Get from remote state
      "arn:aws:s3:::optica-ecs-exec",
    ]
  }
  statement {
    sid = "ECSExecGetEncryptionConfig"
    actions = [
      "s3:GetEncryptionConfiguration"
    ]
    resources = [
      # TODO: Get from remote state
      "arn:aws:s3:::optica-ecs-exec",
    ]
  }
  statement {
    sid = "ECSExecKMSDecrypt"
    actions = [
      "kms:Decrypt"
    ]
    # TODO: get ARN from main infrastructure terraform output
    resources = [
      "arn:aws:kms:us-west-2:445123149871:key/e32433ff-8f7a-4d6b-b908-502d060c115e"
    ]
  }
  # END: Permissions for ECS Exec
}

# Attach policy to daemon role
resource "aws_iam_role_policy_attachment" "ibkr-client-portal-api-policy-attachment" {
  role       = aws_iam_role.ibkr-client-portal-api-role.name
  policy_arn = aws_iam_policy.ibkr-client-portal-api-policy.arn
}
