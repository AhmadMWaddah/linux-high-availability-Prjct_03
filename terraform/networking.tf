# Create Virtual Cloud Network (VCN)
resource "oci_core_vcn" "ha_vcn" {
  compartment_id = var.compartment_ocid
  cidr_block     = var.vcn_cidr
  dns_label      = "havcn"
  display_name   = "ha-prxy-vcn"
}

# Create Subnet for High Availability Proxy
resource "oci_core_subnet" "ha_subnet" {
  compartment_id      = var.compartment_ocid
  vcn_id              = oci_core_vcn.ha_vcn.id
  cidr_block          = var.subnet_cidr
  dns_label           = "hasubnet"
  display_name        = "ha-prxy-subnet"
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  route_table_id      = oci_core_vcn.ha_vcn.default_route_table_id
  security_list_ids   = [oci_core_vcn.ha_vcn.default_security_list_id]
  dhcp_options_id     = oci_core_vcn.ha_vcn.default_dhcp_options_id
}

# Create Internet Gateway
resource "oci_core_internet_gateway" "ha_igw" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.ha_vcn.id
  display_name   = "ha-internet-gateway"
  enabled        = true
}

# Update Route Table to Route 0.0.0.0/0 to IGW
resource "oci_core_default_route_table" "ha_vcn_default_rt" {
  manage_default_resource_id = oci_core_vcn.ha_vcn.default_route_table_id

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.ha_igw.id
  }
}

# Create Security List for DevOps High Availability Practice Lab
resource "oci_core_security_list" "ha_security_list" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.ha_vcn.id
  display_name   = "ha-security-list"

  # Ingress Rules - Allow Port 22 for SSH Access
  ingress_security_rules {
    protocol = "6" # TCP
    source   = var.vcn_cidr
    tcp_options {
      min = 22
      max = 22
    }
    description = "Allow SSH from within VCN"
  }

  # Ingress Rules - Allow Port 80 for HTTP
  ingress_security_rules {
    protocol = "6" # TCP
    source   = var.vcn_cidr
    tcp_options {
      min = 80
      max = 80
    }
    description = "Allow HTTP from within VCN"
  }

  # This rule allows access to HAProxy stats page from within the VCN
  ingress_security_rules {
    protocol = "6" # TCP
    source   = var.vcn_cidr
    tcp_options {
      min = 8080
      max = 8080
    }
    description = "Allow HAProxy stats from within VCN"
  }

  # This rule allows VRRP traffic between load balancers
  ingress_security_rules {
    protocol    = "112" # VRRP
    source      = var.vcn_cidr
    description = "Allow VRRP between load balancers"
  }

  # Egress Rule – allow all outbound
  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
    description = "Allow all outbound traffic"
  }
}

# Block Removed Entirely From Securitly Group Rules List, Not Usable in OCI
# VRRP uses multicast addresses for communication
# ingress_security_rules {
# protocol = "17" # UDP
# source   = "224.0.0.0/24"
# udp_options {
#   min = 1
#   max = 65535
# }
# description = "Allow multicast for VRRP (UDP 1-65535)"
# }