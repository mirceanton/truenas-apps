resource "random_password" "home_ops" {
  length  = 32
  special = true
}
resource "sonatyperepo_user" "home-ops" {
  user_id       = "home-ops"
  first_name    = "HomeOps"
  last_name     = "ServiceAccount"
  email_address = "homeops@mirceanton.com"
  password      = random_password.home_ops.result
  status        = "active"
 
  roles = [ sonatyperepo_role.docker_readonly.id ]
}


resource "random_pet" "dev_user" {
  length    = 3
  separator = "-"
}
resource "sonatyperepo_user" "dev_user" {
  user_id       = "mirceanton"
  first_name    = "Mircea"
  last_name     = "Anton"
  email_address = "mircea@mirceanton.com"
  password      = random_pet.dev_user.id
  status        = "active"

  roles = [ sonatyperepo_role.global_readwrite.id ]
}
output "mirceanton_password" {
  value     = random_pet.dev_user.id
  sensitive = true
}