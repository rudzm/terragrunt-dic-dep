variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "name" {
  type        = string
  description = "Log bucket name"
}

variable "location" {
  type        = string
  default     = "global"
  description = "Location for the log bucket"
}

variable "retention_days" {
  type        = number
  description = "Number of days to retain logs"
}

variable "description" {
  type        = string
  default     = ""
}

variable "labels" {
  type        = map(string)
  default     = {}
}