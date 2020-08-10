variable "enabled" {
  description = "Enabled Module resources creation"
  type        = bool
  default     = true
}

variable "cidr_block" {
  description = "VPC cidr block"
  type        = string
}

variable "max_availability_zones" {
  description = "Maximum AZ to use. Default 3"
  type        = number
  default     = 3
}

variable "enable_dns_support" {
  description = "(Optional) A boolean flag to enable/disable DNS support in the VPC. Defaults true."
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "(Optional) A boolean flag to enable/disable DNS hostnames in the VPC. Default false."
  type        = bool
  default     = true
}

variable "map_public_ip_on_launch" {
  description = "(Optional) Specify true to indicate that instances launched into the subnet should be assigned a public IP address. Default is false."
  type        = bool
  default     = false
}

variable "subnet_tags" {
  description = "Additional tags for subnets"
  type        = map(string)
  default     = {}
}

variable "assign_generated_ipv6_cidr_block" {
  description = "(Optional) Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. Default is false"
  type        = bool
  default     = false
}

variable "nat_gateway_enabled" {
  description = "(Optional) Allow NAT Gateway creation for private subnets. Default is true"
  type        = bool
  default     = true
}

variable "nat_gateway_ha" {
  description = "Set to `true` to deploy as many NAT as private subnets, either only one. Default `false`"
  type        = bool
  default     = false
}

variable "label_formatter" {
  description = "Formatter use to format name or others labels"
  type        = string
  default     = "%s"
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}