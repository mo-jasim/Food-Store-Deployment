# Install the ingress controller before any app ingress resources are applied.
resource "helm_release" "ingress_nginx" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true
  version          = "~> 4.12"

  values = [
    yamlencode({
      controller = {
        ingressClassResource = {
          name = "nginx"
        }
        service = {
          type = "LoadBalancer"
        }
      }
    })
  ]

  depends_on = [module.eks]
}

# Argo CD is exposed through the nginx ingress controller.
resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true

  values = [
    yamlencode({
      configs = {
        params = {
          "server.insecure" = true
        }
      }
      server = {
        service = {
          type = "ClusterIP"
        }
        ingress = {
          enabled          = true
          controller       = "generic"
          ingressClassName = "nginx"
          hostname         = var.argocd_hostname
          path             = "/"
          pathType         = "Prefix"
        }
      }
    })
  ]

  depends_on = [helm_release.ingress_nginx]
}
