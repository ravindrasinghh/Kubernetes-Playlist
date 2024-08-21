variable "region" {
  type        = any
  default     = "ap-south-1"
  description = "value of the region where the resources will be created"
}

variable "environments" {
  type = any

  description = "The environment configuration"
}
