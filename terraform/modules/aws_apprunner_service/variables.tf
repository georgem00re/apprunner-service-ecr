
variable "name" {
  type = string
}

variable "port" {
  type = number
}

variable "image_identifier" {
  type = string
}

variable "auto_scaling_configuration_arn" {
  type = string
}

variable "auto_deployments_enabled" {
  type = bool
}

variable "health_check_path" {
  type = string
}

variable "health_check_protocol" {
  type = string
}

variable "access_role_arn" {
  type = string
}
