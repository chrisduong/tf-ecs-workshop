variable "cluster_id" {
  description = "The ECS cluster ID"
  type        = string
}

variable "app_version" {
  description = "App version"
  type        = string
  default     = "0.1.0"
}
