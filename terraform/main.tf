resource "kubernetes_namespace" "app_ns" {
  metadata {
    annotations = {
      app = var.app_name
      env = var.app_env
    }

    name = local.application_namespace
  }
}

resource "kubernetes_namespace" "db_ns" {
  metadata {
    annotations = {
      app = var.app_name
      env = var.app_env
    }

    name = local.database_namespace
  }
}

resource "helm_release" "postgresql" {
  name       = "postgresql"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "postgresql"
  version    = "13.4.0"
  namespace  = local.database_namespace


  values = [templatefile("templates/postgresql-values.yaml.tpl", {
    db_user         = var.db_user,
    db_password     = var.db_password,
    db_name         = var.db_name,
    db_storageclass = var.db_pvc_storageclass,

  })]

  depends_on = [
    kubernetes_namespace.db_ns,
    ]
}

resource "kubernetes_persistent_volume_claim" "app_data" {
  metadata {
    name      = local.application_persistent_volume_claim_name
    namespace = kubernetes_namespace.app_ns.metadata[0].name
    annotations = {
      app = var.app_name
      env = var.app_env
    }
  }

  spec {
    access_modes       = ["ReadWriteMany"]
    storage_class_name = var.app_pvc_storageclass
    resources {
      requests = {
        storage = "8Gi"
      }
    }
  }

  depends_on = [kubernetes_namespace.db_ns]
}

resource "helm_release" "app" {
  name       = var.app_name
  repository = "https://oteemo.github.io/charts"
  chart      = "sonarqube"
  version    = "9.11.0"
  namespace  = local.application_namespace

  values = [templatefile("templates/sonarqube-values.yaml.tpl", {
    db_user     = var.db_user,
    db_password = var.db_password,
    db_name     = var.db_name,
    db_host     = local.database_hostname,
    app_url     = var.app_url,
    app_persistent_volume_claim_name = kubernetes_persistent_volume_claim.app_data.metadata[0].name
  })]

  depends_on = [
    kubernetes_namespace.app_ns,
    kubernetes_persistent_volume_claim.app_data,
    helm_release.postgresql,
  ]
}