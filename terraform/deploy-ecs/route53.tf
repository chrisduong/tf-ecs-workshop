# module "zones" {
#   source  = "terraform-aws-modules/route53/aws//modules/zones"
#   version = "~> 2.0"

#   zones = {
#     "terraform-aws-modules-example.com" = {
#       comment = "terraform-aws-modules-examples.com (production)"
#       tags = {
#         env = "production"
#       }
#     }

#     "myapp.com" = {
#       comment = "myapp.com"
#     }
#   }

#   tags = {
#     ManagedBy = "Terraform"
#   }
# }

# module "records" {
#   source  = "terraform-aws-modules/route53/aws//modules/records"
#   version = "~> 2.0"

#   zone_name = keys(module.zones.route53_zone_zone_id)[0]

#   records = [
#     {
#       name = "web"
#       type = "A"
#       alias = {
#         name    = "<IP OF THE ALB>"
#         zone_id = "ZLY8HYME6SFAD"
#       }
#     },

#   ]

#   depends_on = [module.zones]
# }
