variable "create" {
  description = "Bool to create"
  type        = bool
  default     = true
}


########
# Label
########
variable "tags" {
  description = "Map of tags for resources"
  type        = map(string)
  default     = {}
}

variable "network_name" {
  description = "The network name, ie kusama / mainnet"
  type        = string
  default     = "testnet"
}

##########
# Provider
##########
variable "project_name" {
  description = "Name of the project in Packet"
  type        = string
}

######
# Node
######

variable "location" {
  description = "Data centre location name"
  type        = string
  default     = "ewr1"
}

variable "machine_type" {
  description = "Instance type"
  type        = string
  default     = "t1.small.x86"
}

variable "public_key" {
  description = "The public key to use"
  type        = string
}

variable "name" {
  description = "Name for resources (i.e. hostname)"
  type        = string
  default     = "w3f"
}

variable "associate_eip" {
  description = "Boolean to determine if you should associate the ip when the instance has been configured"
  type        = bool
  default     = true
}

#########
# Ansible
#########
variable "ansible_hardening" {
  description = "Run hardening roles"
  type        = bool
  default     = false
}

variable "playbook_vars" {
  description = "Additional playbook vars"
  type        = map(string)
  default     = {}
}

variable "keystore_path" {
  description = "The path to the keystore"
  type        = string
  default     = ""
}

variable "keystore_password" {
  description = "The password to the keystore"
  type        = string
  default     = ""
}

variable "private_key_path" {
  description = "Path to the private ssh key"
  type        = string
  default     = ""
}

//variable "playbook_file_path" {
//  description = "The path to the playbook"
//  type        = string
//  default     = ""
//}
//
//variable "user" {
//  description = "The user for configuring node with ansible"
//  type        = string
//  default     = "ubuntu"
//}


//variable "private_key_path" {
//  description = ""
//  type = string
//}
//
//variable "ssh_user" {
//  type = string
//  default = "root"
//}
//
//variable "playbook_file_path" {
//  description = ""
//  type = string
//}
//
//variable "roles_dir" {
//  description = ""
//  type = string
//}
//
//variable "playbook_vars" {
//  description = ""
//  type = map(string)
//  default = {}
//}
