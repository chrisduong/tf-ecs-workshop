variable "cluster_id" {
  description = "The ECS cluster ID"
  type        = string
}

variable "app_version" {
  description = "App version"
  type        = string
  default     = "0.1.0"
}

variable "subnets" {
  description = "App version"
  type        = list(string)
}

variable "security_groups" {
  description = "App version"
  type        = list(string)
}

variable "target_group_arn" {
  description = "App version"
  type        = string
}
