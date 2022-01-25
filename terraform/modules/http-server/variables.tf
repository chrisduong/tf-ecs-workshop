variable "cluster_id" {
  description = "The ECS cluster ID"
  type        = string
}

variable "app_version" {
  type    = string
  default = "0.1.0"
}

variable "subnets" {
  type = list(string)
}

variable "security_groups" {
  type = list(string)
}

variable "target_group_arn" {
  type = string
}

variable "desired_count" {
  default = 2
}

variable "deployment_maximum_percent" {
  default = 100
}

variable "deployment_minimum_healthy_percent" {
  default = 50
}
