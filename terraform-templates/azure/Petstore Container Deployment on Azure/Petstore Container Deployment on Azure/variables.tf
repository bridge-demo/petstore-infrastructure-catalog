

variable "resource_group_name" {
  description = "Name of the Azure resource group where the AKS cluster is located"
  default = "RedThreadPetstore"
}

variable "cluster_name" {
  description = "Name of the AKS cluster"
  default = "RedThreadPetstoreCluster"
}
