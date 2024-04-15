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
locals {
  resource_group_name = module.resource_names["resource_group"].standard
  //public_ip_custom_name = module.resource_names["public_ip"].standard
  virtual_network_name = module.resource_names["hub_vnet"].standard
  #ip_configuration_name = module.resource_names["hub_vnet_ip_configuration"].standard
  # firewall_policy_name                       = module.resource_names["firewall_policy"].standard
  # firewall_policy_rule_collection_group_name = module.resource_names["fw_plcy_rule_colln_grp"].standard
  #custom_diagnostic_settings_name = module.resource_names["custom_diagnostic_settings"].standard


  network_map = {
    "hub_network" = merge(var.network, {
      resource_group_name = local.resource_group_name
      location            = var.location
      vnet_name           = local.virtual_network_name
    })
  }

  # firewall_map = var.create_firewall ? {
  #   "hub_firewall" = merge({
  #     client_name                     = var.logical_product_family
  #     stack                           = var.logical_product_service
  #     resource_group_name             = local.resource_group_name
  #     location                        = var.location
  #     location_short                  = var.location
  #     environment                     = var.class_env
  #     vnet_name                       = local.virtual_network_name
  #     ip_configuration_name           = local.ip_configuration_name
  #     public_ip_name                  = local.public_ip_custom_name
  #     virtual_network_name            = local.virtual_network_name
  #     firewall_policy_id              = module.firewall_policy.id
  #     public_ip_custom_name           = local.public_ip_custom_name
  #     custom_diagnostic_settings_name = local.custom_diagnostic_settings_name,
  #     logs_destinations_ids           = []
  #   }, var.firewall)

  # } : null

  # firewall_public_ip_addresses = var.create_firewall ? module.firewall.public_ip_addresses["hub_firewall"] : null

  # nat_rule_collection = var.nat_rule_collection != null && var.create_firewall ? [
  #   for collection in var.nat_rule_collection : {
  #     name     = collection.name
  #     action   = collection.action
  #     priority = collection.priority
  #     rule = flatten([
  #       for ip in local.firewall_public_ip_addresses : [
  #         for rule in collection.rule : {
  #           name                = rule.name
  #           description         = rule.description
  #           protocols           = rule.protocols
  #           source_addresses    = rule.source_addresses
  #           source_ip_groups    = rule.source_ip_groups
  #           destination_ports   = rule.destination_ports
  #           translated_address  = rule.translated_address
  #           translated_port     = rule.translated_port
  #           translated_fqdn     = rule.translated_fqdn
  #           destination_address = ip
  #         }
  #       ]
  #     ])
  #   }
  # ] : []
}
