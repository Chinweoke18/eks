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

variable "txt_owner_id" {
  description = "A unique identifier to append to the TXT record created by ExternalDNS."
}

variable "domain_filters" {
  type        = list(string)
  description = "A list of domains that ExternalDNS should monitor for changes."
}

variable "policy" {
  default     = "upsert-only"
  description = "The policy that ExternalDNS should use to update DNS records."
}

variable "external_dns_zoneType" {
  description = "External-dns Helm chart AWS DNS zone type (public, private or empty for both)"
  type        = string
  default     = "public"
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