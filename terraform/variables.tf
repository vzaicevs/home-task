variable "app_name" {
  type        = string
  description = "Application name"
}

variable "app_env" {
  type        = string
  description = "Application environment (like prod / dev / stg)"
}

variable "app_url" {
  type        = string
  description = "k8s ingress to create for the application"
}

variable "db_name" {
  type        = string
  description = "PostgreSQL Database name"
}

variable "db_password" {
  type        = string
  description = "PostgreSQL Database Password"
}

variable "db_user" {
  type        = string
  description = "PostgreSQL Database User"
}

variable "db_pvc_storageclass" {
  type        = string
  description = "k8s StorageClass for obtaining persistent volume"
  default     = "standard"
}

variable "app_pvc_storageclass" {
  type        = string
  description = "k8s StorageClass for obtaining persistent volume"
  default     = "standard"
}
