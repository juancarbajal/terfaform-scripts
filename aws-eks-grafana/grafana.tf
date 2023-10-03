provider "kubernetes" {
  config_path    = "~/.kube/config"
}

# Create a Kubernetes namespace for Grafana and Loki
resource "kubernetes_namespace" "grafana_loki_namespace" {
  metadata {
    name = "grafana-loki"
  }
}

# Deploy Grafana using Helm
resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  namespace  = kubernetes_namespace.grafana_loki_namespace.metadata[0].name

  set {
    name  = "adminPassword"
    value = "adminPassword123" # Set your desired Grafana admin password
  }

  set {
    name  = "datasources[0].name"
    value = "Loki"
  }
  set {
    name  = "datasources[0].type"
    value = "loki"
  }
  set {
    name  = "datasources[0].url"
    value = "http://loki:3100" # URL to Loki service
  }

  depends_on = [module.eks]
}

# Deploy Loki using Helm
resource "helm_release" "loki" {
  name       = "loki"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki-stack"
  namespace  = kubernetes_namespace.grafana_loki_namespace.metadata[0].name

  set {
    name  = "loki.persistence.enabled"
    value = "true"
  }

  depends_on = [module.eks]
}
