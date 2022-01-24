data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = terraform.workspace

  cidr = "10.1.0.0/16"

  azs             = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1]]
  private_subnets = ["10.1.1.0/24", "10.1.2.0/24"]
  public_subnets  = ["10.1.11.0/24", "10.1.12.0/24"]

  enable_nat_gateway = true

  tags = {
    Environment = terraform.workspace
    Name        = terraform.workspace
  }
}

#----- ECS --------
module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "3.4.1"

  name               = terraform.workspace
  container_insights = true

  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  default_capacity_provider_strategy = [
    {
      capacity_provider = "FARGATE_SPOT"
    }
  ]

  tags = {
    Environment = terraform.workspace
  }
}

module "ecs_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = "ecs-backend-sg"
  description = "Security group for HTTP traffic to backend"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["10.1.0.0/16"]
  ingress_rules       = ["http-8080-tcp", "all-icmp"]
  egress_rules        = ["all-all"]
}

module "ec2_profile" {
  source  = "terraform-aws-modules/ecs/aws//modules/ecs-instance-profile"
  version = "3.4.1"

  name = terraform.workspace

  tags = {
    Environment = terraform.workspace
  }
}

#----- ECS  Resources--------

#For now we only use the AWS ECS optimized ami <https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html>
data "aws_ami" "amazon_linux_ecs" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

}

#----- ECS  Services--------
module "http_server" {
  source = "../http-server"

  cluster_id       = module.ecs.ecs_cluster_id
  app_version      = var.app_version
  subnets          = module.vpc.private_subnets
  security_groups  = [module.ecs_security_group.security_group_id]
  target_group_arn = element(module.alb.target_group_arns, 0)

}
