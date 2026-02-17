variable "truenas_host" {
  description = "TrueNAS server hostname or IP address"
  type        = string
}

variable "ssh_port" {
  description = "SSH port"
  type        = number
  default     = 22
}

variable "ssh_user" {
  description = "SSH username"
  type        = string
  default     = "root"
}

variable "ssh_private_key_path" {
  description = "Path to SSH private key file"
  type        = string
  default     = "~/.ssh/id_ed25519"
}

variable "ssh_host_key_fingerprint" {
  description = "SHA256 fingerprint of the TrueNAS server SSH host key"
  type        = string
}

variable "op_vault_name" {
  description = "1Password vault name for secrets"
  type        = string
}
