# data "aws_route53_zone" "this" {
#   name = "test.com."
# }

# module "records" {
#   source  = "terraform-aws-modules/route53/aws//modules/records"
#   version = "~> 2.0"

#   zone_name = data.aws_route53_zone.this.zone_id

#   records = [
#     {
#       name = "http-server-dev"
#       type = "A"
#       alias = {
#         name = module.alb.lb_dns_name
#       }
#     }
#   ]

#   depends_on = [module.alb]
# }
