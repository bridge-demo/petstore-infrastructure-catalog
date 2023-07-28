


variable "resource_group_name" {
    type = string
    description = "This resource group name must be new"
}

variable "resource_group_location" {
  type = string
  default = "East US"
  
}



variable kubernetes_cluster_name {
    type = string
    default = "AKSCluster"
    description = "Enter the name of Azure Kubernetes Service Cluster it should contain, only letters, numbers, underscores, and hyphens. The name must start and end with a letter or number."
}

variable kuberntes_dns_prefix {
    type = string
    default = "aksCluster"
    description = "DNS prefix specified when creating the managed cluster. Possible values must begin and end with a letter or number, contain only letters, numbers, and hyphens and be between 1 and 54 characters in length. Changing this forces a new resource to be created."
}

variable kubernetes_cluster_location {
    type = string
    default = "East US"
    description = "The AKS cluster region to deploy the k8s instance "
  
}

variable kubernetes_number_of_nodes {
    type = number
    default = 1
    description = "Number of nodes for the AKS cluster"
}

variable kubernetes_version {
    type = string
    description = "Kubernetes cluster version. Default is set to 1.26.0"
    default = "1.26.0"
}