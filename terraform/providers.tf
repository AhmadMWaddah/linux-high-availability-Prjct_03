# providers.tf
terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 7.0"
    }
  }
}

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  # private_key_path = "/home/amw/.oci/oci_api_key.pem"
  # private_key  = var.private_key_path
  # private_key  = file(var.private_key_path)
  region = var.region
}
