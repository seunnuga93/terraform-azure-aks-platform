project           = "platform"
environment       = "dev"
location          = "uksouth"
address_space     = "10.10.0.0/16"
aks_subnet_prefix = "10.10.0.0/20"
aks_sku_tier      = "Free"
node_vm_size      = "Standard_D2ds_v5"
node_min_count    = 1
node_max_count    = 2
acr_sku           = "Basic"

# Replace with your own public IP / VPN egress range (203.0.113.0/24 is a documentation range).
allowed_ip_ranges = ["203.0.113.10/32"]
