variable "app_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = ""
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = ""
}

variable "cluster_id" {
  description = "Desired name for the IAM user"
  type        = string
}

variable "provider_arn" {
  description = "Desired name for the IAM user"
  type        = string
}

# variable "host" {
#   description = "Desired name for the IAM user"
#   type        = string
# }

# variable "args" {
#   description = "Desired name for the IAM user"
#   type        = string
# }

# variable "cluster_ca_certificate" {
#   description = "Desired name for the IAM user"
#   type        = string
# }