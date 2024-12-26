module "terraform-azurerm-kubernetesservices" {
  source                        = "../modules/aks/"
  name                          = "IBCITEST3MYAKS01"
  dns_prefix                    = "exampleaks1"
  private_cluster_enabled       = true
  local_account_disabled        = true
  kubernetes_version            = "1.29.8"
  sku_tier                      = "Standard"
  public_network_access_enabled = false
  automatic_upgrade_channel     = "stable"
  azure_policy_enabled          = true
  node_os_upgrade_channel       = "NodeImage"
  support_plan                  = "KubernetesOfficial"
  key_vault_network_access      = "Public"
  private_cluster_public_fqdn_enabled = false
  secret_rotation_enabled        = true 
  secret_rotation_interval       = "2m"

  storage_profile = {
    blob_driver_enabled = true
    disk_driver_enabled = true
    file_driver_enabled = true
  }

  network_plugin           = "azure"
  network_policy           = "calico"
  dns_service_ip           = "10.152.0.10"
  outbound_type            = "userDefinedRouting"
  service_cidr             = "10.152.0.0/17"
  pod_cidrs                = 
  network_plugin_mode      = 

  azure_rbac_enabled       = true
  identity_type              = "UserAssigned"        
  httpproxy                  = "http://10.227.3.206:80/"
  httpsproxy                 = "http://10.227.3.206:80/"
  no_proxy                   = ["http://10.227.3.206:80/"]
  tags                       = local.tags
  
  default_node_pool = {
      name             = "ibcitfenp01"
      node_count       = 1
      vm_size          = "Standard_F4s_v2"
      vnet_subnet_id   = "/subscriptions/ac6361f8-4743-4781-946b-fe85b704d358/resourceGroups/IBCI-UAT-TFE-RG01/providers/Microsoft.Network/virtualNetworks/IBCI-UAT-TFE-VNET/subnets/IBCI-UAT-TFE-APP_AKS"
      os_disk_size_gb  = 128
      max_pods         = 30
      only_critical_addons_enabled = true
      orchestrator_version         = "1.27.13"
      max_surge                    = "33%"
      drain_timeout_in_minutes     = "30" 
  }
}
