terraform {
  required_providers {
    truenas = {
      source = "registry.terraform.io/deevus/truenas"
    }
    onepassword = {
      source  = "1Password/onepassword"
      version = "3.2.1"
    }
  }
}

provider "truenas" {
  host        = var.truenas_host
  auth_method = "ssh"

  ssh {
    port                 = var.ssh_port
    user                 = var.ssh_user
    private_key          = file(var.ssh_private_key_path)
    host_key_fingerprint = var.ssh_host_key_fingerprint
  }
}
