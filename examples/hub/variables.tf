// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// resource name module
variable "resource_names_map" {
  description = "A map of key to resource_name that will be used by tf-launch-module_library-resource_name to generate resource names"
  type = map(object({
    name       = string
    max_length = optional(number, 60)
    region     = optional(string, "eastus2")
  }))

  default = {}
}


variable "instance_env" {
  type        = number
  description = "Number that represents the instance of the environment."
  default     = 0

  validation {
    condition     = var.instance_env >= 0 && var.instance_env <= 999
    error_message = "Instance number should be between 0 to 999."
  }
}

variable "instance_resource" {
  type        = number
  description = "Number that represents the instance of the resource."
  default     = 0

  validation {
    condition     = var.instance_resource >= 0 && var.instance_resource <= 100
    error_message = "Instance number should be between 0 to 100."
  }
}

variable "logical_product_family" {
  type        = string
  description = <<EOF
    (Required) Name of the product family for which the resource is created.
    Example: org_name, department_name.
  EOF
  nullable    = false

  validation {
    condition     = can(regex("^[_\\-A-Za-z0-9]+$", var.logical_product_family))
    error_message = "The variable must contain letters, numbers, -, _, and .."
  }

  default = "launch"
}

variable "logical_product_service" {
  type        = string
  description = <<EOF
    (Required) Name of the product service for which the resource is created.
    For example, backend, frontend, middleware etc.
  EOF
  nullable    = false

  validation {
    condition     = can(regex("^[_\\-A-Za-z0-9]+$", var.logical_product_service))
    error_message = "The variable must contain letters, numbers, -, _, and .."
  }

  default = "network"
}

variable "class_env" {
  type        = string
  description = "(Required) Environment where resource is going to be deployed. For example. dev, qa, uat"
  nullable    = false
  default     = "dev"

  validation {
    condition     = length(regexall("\\b \\b", var.class_env)) == 0
    error_message = "Spaces between the words are not allowed."
  }
}

//networking module
variable "network" {
  description = "Attributes of virtual network to be created."
  type = object({
    resource_group_name = string
    location            = string
    vnet_name           = string
    address_space       = optional(list(string), ["10.0.0.0/16"])
    subnets = map(object({
      prefix = string
      delegation = optional(map(object({
        service_name    = string
        service_actions = list(string)
      })), {})
      service_endpoints                             = optional(list(string), []),
      private_endpoint_network_policies_enabled     = optional(bool, false)
      private_link_service_network_policies_enabled = optional(bool, false)
      network_security_group_id                     = optional(string, null)
      route_table_id                                = optional(string, null)
    }))
    bgp_community = optional(string, null)
    ddos_protection_plan = optional(object(
      {
        enable = bool
        id     = string
      }
    ), null)
    dns_servers      = optional(list(string), [])
    nsg_ids          = optional(map(string), {})
    route_tables_ids = optional(map(string), {})
    tags             = optional(map(string), {})
  })
}

variable "location" {
  description = "Azure region to use"
  type        = string
}


variable "firewall" {
  description = "Attributes to create a azure firewall"
  type = object({
    logs_destinations_ids = list(string)
    subnet_cidr           = optional(string)
    additional_public_ips = optional(list(object(
      {
        name                 = string,
        public_ip_address_id = string
    })), [])
    application_rule_collections = optional(list(object(
      {
        name     = string,
        priority = number,
        action   = string,
        rules = list(object(
          { name             = string,
            source_addresses = list(string),
            source_ip_groups = list(string),
            target_fqdns     = list(string),
            protocols = list(object(
              { port = string,
            type = string }))
          }
        ))
    })))
    custom_diagnostic_settings_name = optional(string)
    custom_firewall_name            = optional(string)
    dns_servers                     = optional(string)
    extra_tags                      = optional(map(string))
    firewall_private_ip_ranges      = optional(list(string))
    ip_configuration_name           = optional(string)
    network_rule_collections = optional(list(object({
      name     = string,
      priority = number,
      action   = string,
      rules = list(object({
        name                  = string,
        source_addresses      = list(string),
        source_ip_groups      = optional(list(string)),
        destination_ports     = list(string),
        destination_addresses = list(string),
        destination_ip_groups = optional(list(string)),
        destination_fqdns     = optional(list(string)),
        protocols             = list(string)
      }))
    })))
    public_ip_zones = optional(list(number))
    sku_tier        = string
    zones           = optional(list(number))
  })
  default = null
}

// Firewall Policy Rule Collection Group
variable "firewall_policy_rule_collection_group_priority" {
  description = "(Required) The priority of the Firewall Policy Rule Collection Group. The range is 100-65000."
  type        = number
}

variable "application_rule_collection" {
  description = "(Optional) The Application Rule Collection to use in this Firewall Policy Rule Collection Group."
  type = list(object({
    name     = string
    action   = string
    priority = number
    rule = list(object({
      name        = string
      description = optional(string)
      protocols = optional(list(object({
        type = string
        port = number
      })))
      http_headers = optional(list(object({
        name  = string
        value = string
      })))
      source_addresses      = optional(list(string))
      source_ip_groups      = optional(list(string))
      destination_addresses = optional(list(string))
      destination_urls      = optional(list(string))
      destination_fqdns     = optional(list(string))
      destination_fqdn_tags = optional(list(string))
      terminate_tls         = optional(bool)
      web_categories        = optional(list(string))
    }))
  }))
  default = []
}

variable "network_rule_collection" {
  description = "(Optional) The Network Rule Collection to use in this Firewall Policy Rule Collection Group."
  type = list(object({
    name     = string
    action   = string
    priority = number
    rule = list(object({
      name                  = string
      description           = optional(string)
      protocols             = list(string)
      destination_ports     = list(string)
      source_addresses      = optional(list(string))
      source_ip_groups      = optional(list(string))
      destination_addresses = optional(list(string))
      destination_fqdns     = optional(list(string))
    }))
  }))
  default = []

}

variable "nat_rule_collection" {
  description = "(Optional) The NAT Rule Collection to use in this Firewall Policy Rule Collection Group."
  type = list(object({
    name     = string
    action   = string
    priority = number
    rule = list(object({
      name               = string
      description        = optional(string)
      protocols          = list(string)
      source_addresses   = optional(list(string))
      source_ip_groups   = optional(list(string))
      destination_ports  = optional(list(string))
      translated_address = optional(string)
      translated_port    = number
      translated_fqdn    = optional(string)
    }))
  }))
  default = []
}
