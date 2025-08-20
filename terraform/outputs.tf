# outputs.tf
output "vcn_ocid" {
  value       = oci_core_vcn.ha_vcn.id
  description = "OCID of the created VCN"
}

output "vcn_name" {
  value       = oci_core_vcn.ha_vcn.display_name
  description = "Name of the VCN"
}

output "vcn_cidr" {
  value       = oci_core_vcn.ha_vcn.cidr_block
  description = "CIDR block of the VCN"
}

output "subnet_ocid" {
  value       = oci_core_subnet.ha_subnet.id
  description = "OCID of the created subnet"
}

output "subnet_name" {
  value       = oci_core_subnet.ha_subnet.display_name
  description = "Name of the subnet"
}

output "subnet_cidr" {
  value       = oci_core_subnet.ha_subnet.cidr_block
  description = "CIDR block of the subnet"
}

output "compartment_ocid" {
  value       = var.compartment_ocid
  description = "OCID of the compartment where resources are created"
}