variable "client-info" {
  type        = map(any)
  description = "Synology Client Info"
  default = {
    host     = "1.1.1.1"
    port     = "5001"
    https    = "true"
    username = "synology-csi-user"
    password = "password"
  }
}
