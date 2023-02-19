resource "kubernetes_namespace_v1" "synology-csi" {
  metadata {
    name = "synology-csi"
  }
}

resource "kubernetes_secret_v1" "client-info-secret" {
  metadata {
    name      = "client-info-secret"
    namespace = kubernetes_namespace_v1.synology-csi.id
  }

  data = {
    "client-info.yml" = "${templatefile("${path.module}/config/client-info.tftpl", { client-info = var.client-info })}"
  }
}

resource "kubernetes_manifest" "csi-controller-sa" {
  depends_on = [kubernetes_namespace_v1.synology-csi, kubernetes_secret_v1.client-info-secret]
  manifest   = yamldecode(file("${path.module}/deploy/controller/sa_controller.yml"))
}

resource "kubernetes_manifest" "csi-controller-role" {
  depends_on = [kubernetes_manifest.csi-controller-sa]
  manifest   = yamldecode(file("${path.module}/deploy/controller/role.yml"))
}

resource "kubernetes_manifest" "csi-controller-role-binding" {
  depends_on = [kubernetes_manifest.csi-controller-role]
  manifest   = yamldecode(file("${path.module}/deploy/controller/role_binding.yml"))
}

resource "kubernetes_manifest" "csi-controller-deployment" {
  depends_on = [kubernetes_manifest.csi-controller-role-binding]
  manifest   = yamldecode(file("${path.module}/deploy/controller/deployment.yml"))
}

resource "kubernetes_manifest" "csi-driver" {
  depends_on = [kubernetes_namespace_v1.synology-csi, kubernetes_secret_v1.client-info-secret]
  manifest   = yamldecode(file("${path.module}/deploy/driver/csi-driver.yml"))
}

resource "kubernetes_manifest" "csi-node-sa" {
  depends_on = [kubernetes_namespace_v1.synology-csi, kubernetes_secret_v1.client-info-secret]
  manifest   = yamldecode(file("${path.module}/deploy/node/sa_node.yml"))
}

resource "kubernetes_manifest" "csi-node-role" {
  depends_on = [kubernetes_manifest.csi-node-sa]
  manifest   = yamldecode(file("${path.module}/deploy/node/role.yml"))
}

resource "kubernetes_manifest" "csi-node-role-binding" {
  depends_on = [kubernetes_manifest.csi-controller-role]
  manifest   = yamldecode(file("${path.module}/deploy/node/role_binding.yml"))
}

resource "kubernetes_manifest" "csi-node-deployment" {
  depends_on = [kubernetes_manifest.csi-node-role-binding]
  manifest   = yamldecode(file("${path.module}/deploy/node/deployment.yml"))
}

resource "kubernetes_manifest" "csi-storageclass" {
  depends_on = [kubernetes_namespace_v1.synology-csi, kubernetes_secret_v1.client-info-secret]
  manifest   = yamldecode(templatefile("${path.module}/deploy/storageclass.tftpl", { client-info = var.client-info }))
}
