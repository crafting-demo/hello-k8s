terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.16.0"
    }
  }
}

provider "kubernetes" {
}

resource "kubernetes_namespace" "app" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_deployment" "frontend" {
  metadata {
    name      = "frontend"
    namespace = kubernetes_namespace.app.metadata.0.name
  }

  spec {
    selector {
      match_labels = {
        app = "frontend"
      }
    }
    template {
      metadata {
        labels = {
          app = "frontend"
        }
      }
      spec {
        container {
          name  = "app"
          image = "us-docker.pkg.dev/crafting-playground/demo/hello-k8s/frontend:latest"
          env {
            name  = "BACKEND_URL"
            value = "http://backend:8000"
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "backend" {
  metadata {
    name      = "backend"
    namespace = kubernetes_namespace.app.metadata.0.name
  }

  spec {
    selector {
      match_labels = {
        app = "backend"
      }
    }
    template {
      metadata {
        labels = {
          app = "backend"
        }
      }
      spec {
        container {
          name  = "app"
          image = "us-docker.pkg.dev/crafting-playground/demo/hello-k8s/backend:latest"
        }
      }
    }
  }
}

resource "kubernetes_service" "frontend" {
  metadata {
    name      = "frontend"
    namespace = kubernetes_namespace.app.metadata.0.name
  }
  spec {
    selector = {
      app = "frontend"
    }
    port {
      port = 3000
    }
  }
}

resource "kubernetes_service" "backend" {
  metadata {
    name      = "backend"
    namespace = kubernetes_namespace.app.metadata.0.name
  }
  spec {
    selector = {
      app = "backend"
    }
    port {
      port = 8000
    }
  }
}

# Use kubectl port-forward, no longer need load balancer.
# resource "kubernetes_service" "frontend_lb" {
#   metadata {
#     name      = "frontend-lb"
#     namespace = kubernetes_namespace.app.metadata.0.name
#   }
#   spec {
#     selector = {
#       app = "frontend"
#     }
#     port {
#       port        = 80
#       target_port = 3000
#     }
#     type = "LoadBalancer"
#   }
# }
