resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  version          = "4.0.0"
  values           = [file("./argocd.yaml")]
}
# helm install argocd -n argocd -f values/argocd.yaml
