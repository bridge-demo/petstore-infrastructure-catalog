# Global

#variable client_id {}
#variable client_secret {}
#variable subscription_id {}
#variable tenant_id {}

# Parameters

variable application_tag {
    default = "petstore"
    type = string
    description = "Select an application tag for cam purposes"
    validation {
        condition = contains( ["petstore" ], var.application_tag )
        error_message = "Value should any of the following tags: petstore."
    }
}


variable project_tag {
    type = string
    default = "alpha"
    description = "Select a project tag for cam purposes. Please select among: alpha, bravo or charlie"
    validation {
        condition = contains( ["alpha", "bravo", "charlie" ], var.project_tag )
        error_message = "Value should any of the following tags: alpha, bravo, charlie."
    }
}

variable new_log_analytics_workspace_required {
    type = string
    description = "Select Yes to create a new Log Analytics Workspace. Select an existing analytics workspaces is disabled"
    default = "Yes"
}

variable administrator_login {
    type = string
    default = "Adminazuredb1"
    description = "Database administrator login name. Admin Username Character range should be between 1-16 characters. It must only contain lowercase letters, numbers. Disallowed values: administrator, admin, root, guest, public, azure_superuser."
}

variable administratorPassword  {
    type = string
    default = "Passw0rd1"
    #validation {
    #    condition     = can(regex("((?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])|(?=.*[0-9])(?=.*[a-zA-Z])(?=.*[^A-Za-z0-9])|(?=.*[a-z])(?=.*[A-Z])(?=.*[^A-Za-z0-9])).{8,}", var.administrator_login_password))
    #    error_message = "Database administrator password. It must contain characters from three of the following categories - English uppercase letters, English lowercase letters, numbers (0-9), and non-alphanumeric characters (!, $, #, %, etc.). It must be between 8 & 128 characters."
    #}
}

variable server_name {
    type = string
    description = "Server Name for MySQL.The server name must be between 3-63 characters. It must only contain lowercase letters, numbers, hyphens and must not start & end with a hyphen and be a unique name."
}

variable "resource_group_name" {
    type = string
    description = "This resource group name must be new"
}

variable "resource_group_location" {
  type = string
  default = "East US"
  
}

variable workspace_name {
    type = string
    default = "petstoreAKSWS"
    description = "Enter the name of the workspace. The Workspace name should be between 4-63 characters. It must only contain lowercase letters, numbers, hyphens and must not start & end with a hyphen."
}

variable kubernetes_cluster_name {
    type = string
    default = "petstoreAKSCluster"
    description = "Enter the name of Azure Kubernetes Service Cluster it should contain, only letters, numbers, underscores, and hyphens. The name must start and end with a letter or number."
}
variable snowScriptUrl {
    type = string
    default = "https://example.service-now.com/api/ibmgs/azurehealth"
    description = "The complete snow url that points to the snow script api that converts azure alert schema to snow incidents"
}
variable snowUser {
    type = string
    default = "youruser@example.com"
    description = "Snow user with the permissions to create incidents"
}
variable snowPassword {
    type = string
    default = "passwordExample33"
    description = "Password of the snow user"
}

