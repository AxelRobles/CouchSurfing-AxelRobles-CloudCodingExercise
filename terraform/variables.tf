variable "project_id" {
  type        = string
  description = "GCP project"
  default     = "travis-184605"
}

variable "region" {
  type        = string
  description = "Default region"
  default     = "us-central1"
}

variable "zone" {
  type        = string
  description = "Default zone"
  default     = "us-central1-a"
}

variable "db_password" {
  type        = string
  description = "Password for the database user"
  sensitive   = true
}
