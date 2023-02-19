# synology-csi
Terraform module: Synology CSI Driver for Kubernetes based on the official [Container Storage Interface driver for Synology NAS](https://github.com/SynologyOpenSource/synology-csi)

## Usage

```
module "synology-csi" {
  source = "github.com/ayresfonseca/synology-csi"

  # Connection information for DSM
  client-info = {
    host     = "The IPv4 address of your DSM"
    port     = "The port for connecting to DSM. 5000 (HTTP) and 5001 (HTTPS)"
    https    = "Set 'true' to use HTTPS for secure connections"
    username = "Credentials for connecting to DSM"
    password = "Credentials for connecting to DSM"
  }
}
```

## Limitations

- Supports only one storage system
- Supports only iSCSI Protocol
- Doesn't enable snapshot feature
