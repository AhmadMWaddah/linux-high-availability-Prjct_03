# Required OCIDs
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {
  default = "eu-frankfurt-1"
}

# VCN 
variable "vcn_cidr" {
  description = "CIDR block for the VCN"
  default     = "192.168.222.0/24"
}

# Subnet
variable "subnet_cidr" {
  description = "CIDR block for the subnet"
  default     = "192.168.222.0/25"
}

# Compartment
variable "compartment_ocid" {}

# SSH Key
variable "ssh_public_key_path" {
  default = "/home/amw/Office/DevOps/Projects/RHCSA RHCE GitHub/linux-high-availability-Prjct_03/SSH Keys/Repo3_VMs_key_ed25519.pub"
}

