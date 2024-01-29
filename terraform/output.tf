output "application_helm_release_version" {
  value = helm_release.app.version
}

output "application_helm_release_repository" {
  value = helm_release.app.repository
}

output "application_helm_release_chart" {
  value = helm_release.app.chart
}

output "application_namespace" {
  value = kubernetes_namespace.app_ns.metadata[0].name
}

output "application_persistent_volume_claim_name" {
    value = kubernetes_persistent_volume_claim.app_data.metadata[0].name
}

output "application_url" {
  value = var.app_url
}

output "database_namespace" {
  value = kubernetes_namespace.db_ns.metadata[0].name
}

output "database_helm_release_version" {
  value = helm_release.postgresql.version
}

output "database_helm_release_repository" {
  value = helm_release.postgresql.repository
}

output "database_helm_release_chart" {
  value = helm_release.postgresql.chart
}
