data "onepassword_item" "backblaze" {
  vault = data.onepassword_vault.vault.uuid
  title = "Backblaze B2 Backup Credentials"
}

resource "truenas_cloudsync_credentials" "b2" {
  name = "backblaze-backup"

  b2 {
    account = data.onepassword_item.backblaze.username
    key     = data.onepassword_item.backblaze.password
  }
}

data "onepassword_item" "backblaze_encryption" {
  vault = data.onepassword_vault.vault.uuid
  title = "Backblaze B2 Backup Encryption"
}
resource "truenas_cloudsync_task" "encrypted_backup" {
  # Transfer
  description   = "Encrypted backup to B2"
  direction     = "push"
  transfer_mode = "sync"
  path          = "/mnt/tank/Users/mircea"

  # Remote
  credentials   = truenas_cloudsync_credentials.b2.id
  b2 {
    bucket = "mirceanton-truenas-backup"
    folder = "/Users/mircea"
  }

  # Control
  schedule {
    minute = "0"
    hour   = "0"
  }
  enabled       = false

  # Advanced Options
  snapshot = true
  create_empty_src_dirs = false
  follow_symlinks = false
  fast_list = true
  encryption {
    salt     = data.onepassword_item.backblaze_encryption.username
    password = data.onepassword_item.backblaze_encryption.password
  }
  transfers = 16
}