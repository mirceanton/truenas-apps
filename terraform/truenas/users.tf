
data "truenas_group" "truenas_admin" { name = "truenas_admin" }
data "truenas_group" "terraform" { name = "terraform" }
data "truenas_group" "builtin_users" { name = "builtin_users" }

import {
  to = truenas_group.home
  id = "3002"
}
resource "truenas_group" "home" { name = "Home"}

import {
  to = truenas_group.homelab
  id = "3005"
}
resource "truenas_group" "homelab" { name = "Homelab" }

import {
  to = truenas_group.behind_gates
  id = "3001"
}
resource "truenas_group" "behind_gates" { name = "BehindGates" }

data "truenas_user" "root" { username = "root" }
data "truenas_user" "truenas_admin" { username = "truenas_admin" }
data "truenas_user" "terraform" { username = "terraform" }

import {
  to = truenas_user.bomkii
  id = "3001"
}
resource "truenas_user" "bomkii" {
  username     = "bomkii"
  full_name    = "Bianca-Maria Moga"
  email        = "bianca@bomkii.com"
  shell        = "/usr/sbin/nologin"
  group_id = truenas_group.home.id
  groups   = [
    data.truenas_group.builtin_users.id
  ]
}

import {
  to = truenas_user.mirk
  id = "3000"
}
resource "truenas_user" "mirk" {
  username     = "mirk"
  full_name    = "Mircea-Pavel Anton"
  email        = "mircea@mirceanton.com"
  shell        = "/usr/sbin/nologin"
  group_id = truenas_group.home.id
  groups   = [
    data.truenas_group.builtin_users.id,
    truenas_group.homelab.id,
    truenas_group.behind_gates.id
  ]
}

import {
  to = truenas_user.svc-proxmox
  id = "3002"
}
resource "truenas_user" "svc-proxmox" {
  username     = "svc-proxmox"
  full_name    = "Proxmox Service Account"
  email        = "proxmox@robots.mirceanton.com"
  shell        = "/usr/sbin/nologin"
  group_id = truenas_group.homelab.id
  groups   = [data.truenas_group.builtin_users.id]
}