resource "helm_release" "kube-prometheus-stack" {
  name             = "kube-prometheus-stack"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  version          = "56.21.3"
  namespace        = "monitoring"
  create_namespace = true

  values = [
    file("./kube-prometheus-stack.yaml")
  ]
}
