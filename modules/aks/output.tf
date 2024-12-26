output "kubelet_identity_obj_id" {
    value = azurerm_kubernetes_cluster.azure_kubernetes_cluster.kubelet_identity[0].object_id
}

output "cluster_id" {
    value = azurerm_kubernetes_cluster.azure_kubernetes_cluster.id
}

output "cluster_name" {
    value = azurerm_kubernetes_cluster.azure_kubernetes_cluster.name
}
