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

module "resource_names" {
  source  = "terraform.registry.launch.nttdata.com/module_library/resource_name/launch"
  version = "~> 1.0"

  for_each = var.resource_names_map

  region                  = join("", split("-", var.location))
  class_env               = var.class_env
  cloud_resource_type     = each.value.name
  instance_env            = var.instance_env
  instance_resource       = var.instance_resource
  maximum_length          = each.value.max_length
  logical_product_family  = var.logical_product_family
  logical_product_service = var.logical_product_service
}

module "resource_group" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/resource_group/azurerm"
  version = "~> 1.0"

  name     = local.resource_group_name
  location = var.location
  tags = {
    resource_name = local.resource_group_name
  }
}

module "network" {
  source  = "terraform.registry.launch.nttdata.com/module_collection/virtual_network/azurerm"
  version = "~> 1.1.0"

  network_map = local.network_map
  depends_on  = [module.resource_group]
}

module "firewall" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/firewall/azurerm"
  version = "~> 1.0"

  firewall_map = local.firewall_map

  depends_on = [module.network, module.resource_group]
}

module "firewall_policy" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/firewall_policy/azurerm"
  version = "~> 1.0"

  name                = local.firewall_policy_name
  resource_group_name = local.resource_group_name
  location            = var.location

  depends_on = [module.network]
}

module "firewall_policy_rule_collection_group" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/firewall_policy_rule_collection_group/azurerm"
  version = "~> 1.0"

  name                        = local.firewall_policy_rule_collection_group_name
  firewall_policy_id          = module.firewall_policy.id
  priority                    = var.firewall_policy_rule_collection_group_priority
  application_rule_collection = var.application_rule_collection
  network_rule_collection     = var.network_rule_collection
  nat_rule_collection         = local.nat_rule_collection

  depends_on = [module.firewall_policy, module.firewall]
}
