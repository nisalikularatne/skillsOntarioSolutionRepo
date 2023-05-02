variable "namespace" {
  type        = string
  description = "Project name"
  default     = "competition"
}

variable "name" {
  type        = string
  description = "name"
  default     = "skills-ontario-final"
}

variable "environments" {
  description = "Environments"
  type        = list(string)
  default     = ["dev", "prod"]
}
