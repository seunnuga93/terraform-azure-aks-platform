project           = "platform"
environment       = "prod"
location          = "uksouth"
address_space     = "10.20.0.0/16"
aks_subnet_prefix = "10.20.0.0/20"
aks_sku_tier      = "Standard"
node_vm_size      = "Standard_D4ds_v5"
node_min_count    = 2
node_max_count    = 5
acr_sku           = "Standard"

# Replace with your own public IP / VPN egress range (203.0.113.0/24 is a documentation range).
allowed_ip_ranges = ["203.0.113.10/32"]
