module "alb_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = "alb-sg-web"
  description = "Security group for web traffic"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "all-icmp", "https-443-tcp"]
  egress_rules        = ["all-all"]
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  name = "my-alb"

  load_balancer_type = "application"

  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.public_subnets
  security_groups = [module.alb_security_group.security_group_id]

  http_tcp_listeners = [
    {
      port        = 80
      protocol    = "HTTP"
      action_type = "redirect"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  ]

  https_listeners = [
    {
      port     = 443
      protocol = "HTTPS"
      // Use self-signed *.example.com for 18.158.223.254
      // aws iam upload-server-certificate --server-certificate-name example.com  --certificate-body file://example.com+8.pem --private-key file://example.com+8-key.pem
      certificate_arn = "arn:aws:iam::415376140508:server-certificate/example.com"
    },
  ]

  target_groups = [
    {
      name_prefix          = "h1"
      backend_protocol     = "HTTP"
      backend_port         = 8080
      target_type          = "ip"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/version"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      protocol_version = "HTTP1"
      tags = {
        InstanceTargetGroupTag = "http-server"
      }
    }
  ]

  tags = {
    Environment = "Test"
  }
}

# module "acm" {
#   source  = "terraform-aws-modules/acm/aws"
#   version = "~> 3.0"

#   domain_name = keys(module.zones.route53_zone_name_servers)[0]
#   zone_id     = keys(module.zones.route53_zone_zone_id)[0]
# }
