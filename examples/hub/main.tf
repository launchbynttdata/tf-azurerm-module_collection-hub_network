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

module "hub_vnet" {
  source = "../.."

  resource_names_map      = var.resource_names_map
  instance_env            = var.instance_env
  class_env               = var.class_env
  logical_product_family  = var.logical_product_family
  logical_product_service = var.logical_product_service
  instance_resource       = var.instance_resource
  location                = var.location

  network = var.network
  # create_firewall                                = var.create_firewall
  # firewall                                       = var.firewall
  # firewall_policy_rule_collection_group_priority = var.firewall_policy_rule_collection_group_priority
  # application_rule_collection                    = var.application_rule_collection
  # network_rule_collection                        = var.network_rule_collection
  # nat_rule_collection                            = var.nat_rule_collection
}
