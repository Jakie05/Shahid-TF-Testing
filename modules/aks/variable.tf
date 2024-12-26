variable "name" {
  type = string
  description = " (Required) The name of the Managed Kubernetes Cluster to create. Changing this forces a new resource to be created."
}

variable "dns_prefix" {
  type = string
  description = "(Optional) DNS prefix specified when creating the managed cluster. Possible values must begin and end with a letter or number, contain only letters, numbers, and hyphens and be between 1 and 54 characters in length. Changing this forces a new resource to be created."
}

variable "private_cluster_enabled" {
  default = true
  description = "Should this Kubernetes Cluster have its API server only exposed on internal IP addresses? This provides a Private IP Address for the Kubernetes API on the Virtual Network where the Kubernetes Cluster is located. Defaults to false. Changing this forces a new resource to be created."
}

variable "local_account_disabled" {
  type = bool
  default = true
  description = "To enable Kubernetes RBAC and AKS-managed Azure AD integration."
}

variable "kubernetes_version" {
  type = string
  description = "Version of Kubernetes specified when creating the AKS managed cluster. If not specified, the latest recommended version will be used at provisioning time (but won't auto-upgrade). AKS does not require an exact patch version to be specified, minor version aliases such as 1.22 are also supported. - The minor version's latest GA patch is automatically chosen in that case."
}

variable "sku_tier" {
  type = string
  default = "Standard"
  description = " The SKU Tier that should be used for this Kubernetes Cluster. Possible values are Free, and Standard (which includes the Uptime SLA). Defaults to Free."
}

variable "public_network_access_enabled" {
  default = false
  description = "Whether public network access is allowed for this Kubernetes Cluster. Defaults to true. Changing this forces a new resource to be created."
}

variable "automatic_upgrade_channel" {
  default = "none"
  description = "The upgrade channel for this Kubernetes Cluster. Possible values are patch, rapid, node-image and stable. Omitting this field sets this value to none."
}

variable "azure_policy_enabled" { 
  type = bool
  default = true
  description = "Should the Azure Policy Add-On be enabled"
}

variable "node_os_upgrade_channel" {
  type = string
  description = "The upgrade channel for this Kubernetes Cluster Nodes OS Image"
}

variable "support_plan" {
  type = string
  description = "Specifies the support plan which should be used for this Kubernetes Cluster"
}

variable "private_cluster_public_fqdn_enabled" {
  default = false
  description = "Specifies whether a Public FQDN for this Private Cluster should be added. Defaults to false."
}

variable "key_vault_network_access" { 
  type = string
  default = "Public"
  description = "Network access of the key vault Network access of key vault. The possible values are Public and Private"
}

variable "secret_rotation_enabled" {
  type = bool
  default = true
  description = "(Optional) A key_vault_secrets_provider block as defined below. For more details, please visit Azure Keyvault Secrets Provider for AKS."
}

variable "secret_rotation_interval" {
  type = string
  description = "The interval to poll for secret rotation."
}

variable "network_plugin" {
  type = string
  description = "Network plugin to use for networking. Currently supported values are azure, kubenet and none. Changing this forces a new resource to be created."
}

variable "network_policy" {
  type = string
  description = "Sets up network policy to be used with Azure CNI. Network policy allows us to control the traffic flow between pods. Currently supported values are calico and azure. Changing this forces a new resource to be created."
}

variable "dns_service_ip" {
  type = string
  description = " IP address within the Kubernetes service address range that will be used by cluster service discovery (kube-dns). Changing this forces a new resource to be created."
}

variable "outbound_type" {
  type = string
  description = "The outbound (egress) routing method which should be used for this Kubernetes Cluster. Possible values are loadBalancer, userDefinedRouting, managedNATGateway and userAssignedNATGateway. Defaults to loadBalancer. Changing this forces a new resource to be created."
}

variable "service_cidr" {
  type = string
  description = "The Network Range used by the Kubernetes service. Changing this forces a new resource to be created."
}

variable "pod_cidrs" {
  type = list(string)
  description = ""
}

variable "network_plugin_mode" {
  type = string
  description = "Specifies the network plugin mode used for building the Kubernetes network."
}

variable "default_node_pool" { 
  type = map(any)
  default = {}
  description = "System Assigned NodePool Configuration"
}

variable "storage_profile" { 
  type = map(any)
  default = {}
  description = "Storage CSI driver Configuration"
}

variable "azure_rbac_enabled" { 
  type = bool
  default = true
  description = "Is Role Based Access Control based on Azure AD enabled"
}

variable "tenant_id" {
  type = string
  description = "The Tenant ID used for Azure Active Directory Application. If this isn't specified the Tenant ID of the current Subscription is used."
}

variable "httpproxy" {
  type = string
  description = "The proxy address to be used when communicating over HTTP. Changing this forces a new resource to be created."
}

variable "httpsproxy" {
  type = string
  description = "The proxy address to be used when communicating over HTTPS. Changing this forces a new resource to be created."
}

variable "no_proxy" {
  type = list(string)
  description = "The list of domains that will not use the proxy for communication. Changing this forces a new resource to be created."
}

variable "tags" {
  type = map(any)
  description = "A map of tags to assign to the resource."
}
