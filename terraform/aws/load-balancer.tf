resource "aws_alb" "ibkr-client-portal-api" {
  name               = "${terraform.workspace}-${local.service-name}"
  internal           = false
  load_balancer_type = "application"

  subnets = [
    data.terraform_remote_state.infra-core.outputs.subnet.public.us-west-2a.id,
    data.terraform_remote_state.infra-core.outputs.subnet.public.us-west-2b.id,
    data.terraform_remote_state.infra-core.outputs.subnet.public.us-west-2c.id,
    data.terraform_remote_state.infra-core.outputs.subnet.public.us-west-2d.id,
  ]

  security_groups = [
    data.terraform_remote_state.infra-core.outputs.security-group.egress-all.id,
    data.terraform_remote_state.infra-core.outputs.security-group.ingress-http.id,
    data.terraform_remote_state.infra-core.outputs.security-group.ingress-https.id,
  ]

  lifecycle {
    create_before_destroy = true
  }

  tags = local.tags
}


resource "aws_lb_target_group" "ibkr-client-portal-api-tg-5000" {
  name        = "${terraform.workspace}-${local.service-name}"
  port        = 5000
  protocol    = "HTTPS"
  target_type = "ip"
  vpc_id      = data.terraform_remote_state.infra-core.outputs.vpc.default.id

  health_check {
    enabled = true
    path    = "/livez"
    port    = 5001
  }

  depends_on = [aws_alb.ibkr-client-portal-api]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_alb.ibkr-client-portal-api.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_alb_listener" "https" {
  load_balancer_arn = aws_alb.ibkr-client-portal-api.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = data.terraform_remote_state.infra-core.outputs.dns.us-west-2-acm-certificate-arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ibkr-client-portal-api-tg-5000.arn
  }

  lifecycle {
    create_before_destroy = true
  }
}

