terraform {
  required_version = ">= 0.13.0"

  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.9.11"
    }
  }
}

provider "proxmox" {
  pm_tls_insecure = "true"
  pm_api_url      = "https://192.168.178.25:8006/api2/json"
  pm_user         = "root@pam"
  pm_password     = var.pm_password
  pm_parallel     = 2
}