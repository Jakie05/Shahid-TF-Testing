resource "azurerm_resource_group" "azure_resource_group" {
  name     = "example-resources"
  location = "US East 1"
}

resource "azurerm_network_security_group" "example" {
  name                = "example-security-group"
  location            =  azurerm_resource_group.azure_resource_group.location
  resource_group_name = azurerm_resource_group.azure_resource_group.name
}

resource "azurerm_virtual_network" "example" {
  name                = "example-network"
  location            =  azurerm_resource_group.azure_resource_group.location
  resource_group_name = azurerm_resource_group.azure_resource_group.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  tags = {
    environment = "Production"
  }
}

resource "azurerm_subnet" "example_subnet" {
  name             = "subnet1"
  resource_group_name  = azurerm_resource_group.azure_resource_group.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_disk_encryption_set" "example_des" {
  name                = "exampleDESet"
  resource_group_name = azurerm_resource_group.azure_resource_group.name
  location            =  azurerm_resource_group.azure_resource_group.location
  key_vault_key_id    = azurerm_key_vault_key.generated.id

  identity {
    type = "SystemAssigned"
  }
}


resource "azurerm_key_vault" "example" {
  name                       = "examplekeyvault"
  location            =  azurerm_resource_group.azure_resource_group.location
  resource_group_name = azurerm_resource_group.azure_resource_group.name
  tenant_id                  = var.tenant_id
  sku_name                   = "premium"
  soft_delete_retention_days = 7

}

resource "azurerm_key_vault_key" "generated" {
  name         = "generated-certificate"
  key_vault_id = azurerm_key_vault.example.id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
}

resource "azurerm_private_dns_zone" "example" {
  name                = "privatelink.eastus2.azmk8s.io"
  resource_group_name = azurerm_resource_group.azure_resource_group.name
}

resource "azurerm_user_assigned_identity" "example" {
  name                = "aks-example-identity"
  resource_group_name = azurerm_resource_group.azure_resource_group.name
  location            = azurerm_resource_group.azure_resource_group.location
}

resource "azurerm_role_assignment" "example" {
  scope                = azurerm_private_dns_zone.example.id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.example.principal_id
}

resource "azurerm_container_registry" "azure_container_registry" {
  name                = "containerRegistry1"
  resource_group_name = azurerm_resource_group.azure_resource_group.name
  location            = azurerm_resource_group.azure_resource_group.location
  sku                 = "Premium"
  admin_enabled       = false
  georeplications {
    location                = "East US"
    zone_redundancy_enabled = true
    tags                    = {}
  }
}

resource "azurerm_role_assignment" "role_assignment" {
  principalid = azurerm_kubernetes_cluster.azure_kubernetes_cluster.kubelet_identity_obj_id
  role        = "AcrPull"
  scope       = azurerm_container_registry.azure_container_registry.id
}

resource "azurerm_kubernetes_cluster" "azure_kubernetes_cluster" {
  name                                = var.name	 
  location                            = azurerm_resource_group.azure_resource_group.location
  resource_group_name                 = azurerm_resource_group.azure_resource_group.name
  dns_prefix                          = var.dns_prefix	
  private_cluster_enabled             = var.private_cluster_enabled
  local_account_disabled              = var.local_account_disabled
  kubernetes_version	              = var.kubernetes_version	
  private_dns_zone_id                 = azurerm_private_dns_zone.example.id
  sku_tier                            = var.sku_tier
  automatic_upgrade_channel           = var.automatic_upgrade_channel
  disk_encryption_set_id              = var.disk_encryption_set_id
  azure_policy_enabled                = var.azure_policy_enabled
  node_os_upgrade_channel             = var.node_os_upgrade_channel
  support_plan                        = var.support_plan
  private_cluster_public_fqdn_enabled = var.private_cluster_public_fqdn_enabled

  key_management_service {
    key_vault_key_id         = azurerm_key_vault_key.generated.id
    key_vault_network_access = var.key_vault_network_access
  }

  storage_profile {
    blob_driver_enabled = lookup(var.storage_profile, "blob_driver_enabled", true)
    disk_driver_enabled = lookup(var.storage_profile, "disk_driver_enabled", true)
    file_driver_enabled = lookup(var.storage_profile, "file_driver_enabled", true)
  }


  key_vault_secrets_provider {
    secret_rotation_enabled  = var.secret_rotation_enabled
    secret_rotation_interval = var.secret_rotation_interval
  }

  network_profile {
    network_plugin      = var.network_plugin
    network_policy      = var.network_policy
    dns_service_ip	= var.dns_service_ip
    outbound_type	= var.outbound_type
    service_cidr	= var.service_cidr
    pod_cidrs           = var.pod_cidrs
    network_plugin_mode = var.network_plugin_mode
  }
	
  default_node_pool {
    name                         = lookup(var.default_node_pool, "name", null)
    vm_size                      = lookup(var.default_node_pool, "vm_size", null)
    vnet_subnet_id	         = lookup(var.default_node_pool, "vnet_subnet_id", null)
    auto_scaling_enabled         = lookup(var.default_node_pool, "auto_scaling_enabled", false)
    os_disk_size_gb              = lookup(var.default_node_pool, "os_disk_size_gb", null)
    max_pods	                 = lookup(var.default_node_pool, "max_pods", null)
    node_count                   = lookup(var.default_node_pool, "node_count", null)
    max_count                    = lookup(var.default_node_pool, "max_count", null)
    min_count                    = lookup(var.default_node_pool, "min_count", null)
    host_encryption_enabled      = lookup(var.default_node_pool, "host_encryption_enabled", false)
    temporary_name_for_rotation  = lookup(var.default_node_pool, "temporary_name_for_rotation", null)
    only_critical_addons_enabled = lookup(var.default_node_pool, "only_critical_addons_enabled", null)
    orchestrator_version         = lookup(var.default_node_pool, "orchestrator_version", null)
	  
    upgrade_settings {
      max_surge                  = lookup(var.default_node_pool, "max_surge", null)
      drain_timeout_in_minutes   = lookup(var.default_node_pool, "drain_timeout_in_minutes", null)
    }
  }
	
  azure_active_directory_role_based_access_control {
    azure_rbac_enabled     = var.azure_rbac_enabled
    tenant_id              = var.tenant_id
  }
	
  identity {
    type 	 = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.example.id]
  }
	
  http_proxy_config {
    http_proxy  = var.httpproxy
    https_proxy = var.httpsproxy
    no_proxy    = var.no_proxy
  }
	
  timeouts {
    create 	= "25m"
    read 	= "25m"
    delete 	= "30m"
    update 	= "30m" 
  }
	
  tags  = var.tags
	    
  lifecycle {
     ignore_changes = [http_proxy_config["no_proxy"],]     
  }
}
