locals {
  application_namespace        = "${var.app_name}-${var.app_env}"
  application_persistent_volume_claim_name = "${var.app_name}-data"
  database_namespace           = "${var.app_name}-postgresql-${var.app_env}"
  database_hostname            = "postgresql.${local.database_namespace}.svc.cluster.local"
}