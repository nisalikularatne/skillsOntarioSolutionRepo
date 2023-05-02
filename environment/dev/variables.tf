variable "ipv4_primary_cidr_block" {
  type        = string
  description = <<-EOT
    The primary IPv4 CIDR block for the VPC.
    Either `ipv4_primary_cidr_block` or `ipv4_primary_cidr_block_association` must be set, but not both.
    EOT
  default     = "10.0.0.0/16"
}
variable "name" {
  type        = string
  description = "Name description"
  default     = "skills-ontario"
}
variable "stage" {
  type        = string
  description = "Deployment stage, e.g. dev, test, prod"
  default     = "dev"
}
variable "container_port" {
  type        = number
  description = "The port the application listens on"
  default     = 8080
}

variable "service_desired_count" {
  type        = number
  description = "The desired number of tasks per service"
  default     = 2
}
variable "domain_name" {
  type        = string
  description = "DNS name you own"
  default     = "skillsontarioaws.xyz"
}
variable "namespace" {
  type        = string
  description = "Project name"
  default     = "competition"
}
