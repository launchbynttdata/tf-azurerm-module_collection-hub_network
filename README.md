# tf-azurerm-module_collection-hub_network

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![License: CC BY-NC-ND 4.0](https://img.shields.io/badge/License-CC_BY--NC--ND_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-nd/4.0/)

## Overview

This module
- Creates the standard names for the resources to be deployed
- Creates
  - Resource group for the VNET and related resource's
  - Virtual network to be treated as hub virtual network
  - Firewall along with private and public IP addresses
  - Firewall Policy
  - Rules attached to the policy

## Pre-Commit hooks

[.pre-commit-config.yaml](.pre-commit-config.yaml) file defines certain `pre-commit` hooks that are relevant to terraform, golang and common linting tasks. There are no custom hooks added.

`commitlint` hook enforces commit message in certain format. The commit contains the following structural elements, to communicate intent to the consumers of your commit messages:

- **fix**: a commit of the type `fix` patches a bug in your codebase (this correlates with PATCH in Semantic Versioning).
- **feat**: a commit of the type `feat` introduces a new feature to the codebase (this correlates with MINOR in Semantic Versioning).
- **BREAKING CHANGE**: a commit that has a footer `BREAKING CHANGE:`, or appends a `!` after the type/scope, introduces a breaking API change (correlating with MAJOR in Semantic Versioning). A BREAKING CHANGE can be part of commits of any type.
footers other than BREAKING CHANGE: <description> may be provided and follow a convention similar to git trailer format.
- **build**: a commit of the type `build` adds changes that affect the build system or external dependencies (example scopes: gulp, broccoli, npm)
- **chore**: a commit of the type `chore` adds changes that don't modify src or test files
- **ci**: a commit of the type `ci` adds changes to our CI configuration files and scripts (example scopes: Travis, Circle, BrowserStack, SauceLabs)
- **docs**: a commit of the type `docs` adds documentation only changes
- **perf**: a commit of the type `perf` adds code change that improves performance
- **refactor**: a commit of the type `refactor` adds code change that neither fixes a bug nor adds a feature
- **revert**: a commit of the type `revert` reverts a previous commit
- **style**: a commit of the type `style` adds code changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
- **test**: a commit of the type `test` adds missing tests or correcting existing tests

Base configuration used for this project is [commitlint-config-conventional (based on the Angular convention)](https://github.com/conventional-changelog/commitlint/tree/master/@commitlint/config-conventional#type-enum)

If you are a developer using vscode, [this](https://marketplace.visualstudio.com/items?itemName=joshbolduc.commitlint) plugin may be helpful.

`detect-secrets-hook` prevents new secrets from being introduced into the baseline. TODO: INSERT DOC LINK ABOUT HOOKS

In order for `pre-commit` hooks to work properly

- You need to have the pre-commit package manager installed. [Here](https://pre-commit.com/#install) are the installation instructions.
- `pre-commit` would install all the hooks when commit message is added by default except for `commitlint` hook. `commitlint` hook would need to be installed manually using the command below

```
pre-commit install --hook-type commit-msg
```

## To test the resource group module locally

1. For development/enhancements to this module locally, you'll need to install all of its components. This is controlled by the `configure` target in the project's [`Makefile`](./Makefile). Before you can run `configure`, familiarize yourself with the variables in the `Makefile` and ensure they're pointing to the right places.

```
make configure
```

This adds in several files and directories that are ignored by `git`. They expose many new Make targets.

2. _THIS STEP APPLIES ONLY TO MICROSOFT AZURE. IF YOU ARE USING A DIFFERENT PLATFORM PLEASE SKIP THIS STEP._ The first target you care about is `env`. This is the common interface for setting up environment variables. The values of the environment variables will be used to authenticate with cloud provider from local development workstation.

`make configure` command will bring down `azure_env.sh` file on local workstation. Devloper would need to modify this file, replace the environment variable values with relevant values.

These environment variables are used by `terratest` integration suit.

Service principle used for authentication(value of ARM_CLIENT_ID) should have below privileges on resource group within the subscription.

```
"Microsoft.Resources/subscriptions/resourceGroups/write"
"Microsoft.Resources/subscriptions/resourceGroups/read"
"Microsoft.Resources/subscriptions/resourceGroups/delete"
```

Then run this make target to set the environment variables on developer workstation.

```
make env
```

3. The first target you care about is `check`.

**Pre-requisites**
Before running this target it is important to ensure that, developer has created files mentioned below on local workstation under root directory of git repository that contains code for primitives/segments. Note that these files are `azure` specific. If primitive/segment under development uses any other cloud provider than azure, this section may not be relevant.

- A file named `provider.tf` with contents below

```
provider "azurerm" {
  features {}
}
```

- A file named `terraform.tfvars` which contains key value pair of variables used.

Note that since these files are added in `gitignore` they would not be checked in into primitive/segment's git repo.

After creating these files, for running tests associated with the primitive/segment, run

```
make check
```

If `make check` target is successful, developer is good to commit the code to primitive/segment's git repo.

`make check` target

- runs `terraform commands` to `lint`,`validate` and `plan` terraform code.
- runs `conftests`. `conftests` make sure `policy` checks are successful.
- runs `terratest`. This is integration test suit.
- runs `opa` tests
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | <= 1.5.5 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.77 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_resource_names"></a> [resource\_names](#module\_resource\_names) | git::https://github.com/launchbynttdata/tf-launch-module_library-resource_name.git | 1.0.0 |
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | git::https://github.com/launchbynttdata/tf-azurerm-module_primitive-resource_group.git | 1.0.0 |
| <a name="module_network"></a> [network](#module\_network) | git::https://github.com/launchbynttdata/tf-azurerm-module_collection-virtual_network.git | 1.0.0 |
| <a name="module_firewall"></a> [firewall](#module\_firewall) | git::https://github.com/launchbynttdata/tf-azurerm-module_primitive-firewall.git | 1.0.0 |
| <a name="module_firewall_policy"></a> [firewall\_policy](#module\_firewall\_policy) | git::https://github.com/launchbynttdata/tf-azurerm-module_primitive-firewall_policy.git | 1.0.0 |
| <a name="module_firewall_policy_rule_collection_group"></a> [firewall\_policy\_rule\_collection\_group](#module\_firewall\_policy\_rule\_collection\_group) | git::https://github.com/launchbynttdata/tf-azurerm-module_primitive-firewall_policy_rule_collection_group.git | 1.0.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_resource_names_map"></a> [resource\_names\_map](#input\_resource\_names\_map) | A map of key to resource\_name that will be used by tf-launch-module\_library-resource\_name to generate resource names | <pre>map(object({<br>    name       = string<br>    max_length = optional(number, 60)<br>    region     = optional(string, "eastus2")<br>  }))</pre> | <pre>{<br>  "firewall": {<br>    "max_length": 80,<br>    "name": "fw"<br>  },<br>  "firewall_policy": {<br>    "max_length": 80,<br>    "name": "fwplcy"<br>  },<br>  "fw_plcy_rule_colln_grp": {<br>    "max_length": 80,<br>    "name": "fwplcyrulecollngrp"<br>  },<br>  "hub_vnet": {<br>    "max_length": 80,<br>    "name": "hubvnet"<br>  },<br>  "hub_vnet_ip_configuration": {<br>    "max_length": 80,<br>    "name": "ipconfig"<br>  },<br>  "log_analytics_workspace": {<br>    "max_length": 80,<br>    "name": "law"<br>  },<br>  "public_ip": {<br>    "max_length": 80,<br>    "name": "pip"<br>  },<br>  "resource_group": {<br>    "max_length": 80,<br>    "name": "hubrg"<br>  }<br>}</pre> | no |
| <a name="input_instance_env"></a> [instance\_env](#input\_instance\_env) | Number that represents the instance of the environment. | `number` | `0` | no |
| <a name="input_instance_resource"></a> [instance\_resource](#input\_instance\_resource) | Number that represents the instance of the resource. | `number` | `0` | no |
| <a name="input_logical_product_family"></a> [logical\_product\_family](#input\_logical\_product\_family) | (Required) Name of the product family for which the resource is created.<br>    Example: org\_name, department\_name. | `string` | `"launch"` | no |
| <a name="input_logical_product_service"></a> [logical\_product\_service](#input\_logical\_product\_service) | (Required) Name of the product service for which the resource is created.<br>    For example, backend, frontend, middleware etc. | `string` | `"network"` | no |
| <a name="input_class_env"></a> [class\_env](#input\_class\_env) | (Required) Environment where resource is going to be deployed. For example. dev, qa, uat | `string` | `"dev"` | no |
| <a name="input_network"></a> [network](#input\_network) | Attributes of virtual network to be created. | <pre>object({<br>    use_for_each    = bool<br>    address_space   = optional(list(string), ["10.0.0.0/16"])<br>    subnet_names    = optional(list(string), [])<br>    subnet_prefixes = optional(list(string), [])<br>    bgp_community   = optional(string, null)<br>    ddos_protection_plan = optional(object(<br>      {<br>        enable = bool<br>        id     = string<br>      }<br>    ), null)<br>    dns_servers                                           = optional(list(string), [])<br>    nsg_ids                                               = optional(map(string), {})<br>    route_tables_ids                                      = optional(map(string), {})<br>    subnet_delegation                                     = optional(map(map(any)), {})<br>    subnet_enforce_private_link_endpoint_network_policies = optional(map(bool), {})<br>    subnet_enforce_private_link_service_network_policies  = optional(map(bool), {})<br>    subnet_service_endpoints                              = optional(map(list(string)), {})<br>    tags                                                  = optional(map(string), {})<br>    tracing_tags_enabled                                  = optional(bool, false)<br>    tracing_tags_prefix                                   = optional(string, "")<br>  })</pre> | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Azure region to use | `string` | n/a | yes |
| <a name="input_firewall"></a> [firewall](#input\_firewall) | Attributes to create a azure firewall | <pre>object({<br>    logs_destinations_ids = list(string)<br>    subnet_cidr           = optional(string)<br>    additional_public_ips = optional(list(object(<br>      {<br>        name                 = string,<br>        public_ip_address_id = string<br>    })), [])<br>    application_rule_collections = optional(list(object(<br>      {<br>        name     = string,<br>        priority = number,<br>        action   = string,<br>        rules = list(object(<br>          { name             = string,<br>            source_addresses = list(string),<br>            source_ip_groups = list(string),<br>            target_fqdns     = list(string),<br>            protocols = list(object(<br>              { port = string,<br>            type = string }))<br>          }<br>        ))<br>    })))<br>    custom_diagnostic_settings_name = optional(string)<br>    custom_firewall_name            = optional(string)<br>    dns_servers                     = optional(string)<br>    extra_tags                      = optional(map(string))<br>    firewall_private_ip_ranges      = optional(list(string))<br>    ip_configuration_name           = optional(string)<br>    network_rule_collections = optional(list(object({<br>      name     = string,<br>      priority = number,<br>      action   = string,<br>      rules = list(object({<br>        name                  = string,<br>        source_addresses      = list(string),<br>        source_ip_groups      = optional(list(string)),<br>        destination_ports     = list(string),<br>        destination_addresses = list(string),<br>        destination_ip_groups = optional(list(string)),<br>        destination_fqdns     = optional(list(string)),<br>        protocols             = list(string)<br>      }))<br>    })))<br>    public_ip_zones = optional(list(number))<br>    sku_tier        = string<br>    zones           = optional(list(number))<br>  })</pre> | `null` | no |
| <a name="input_firewall_policy_rule_collection_group_priority"></a> [firewall\_policy\_rule\_collection\_group\_priority](#input\_firewall\_policy\_rule\_collection\_group\_priority) | (Required) The priority of the Firewall Policy Rule Collection Group. The range is 100-65000. | `number` | n/a | yes |
| <a name="input_application_rule_collection"></a> [application\_rule\_collection](#input\_application\_rule\_collection) | (Optional) The Application Rule Collection to use in this Firewall Policy Rule Collection Group. | <pre>list(object({<br>    name     = string<br>    action   = string<br>    priority = number<br>    rule = list(object({<br>      name        = string<br>      description = optional(string)<br>      protocols = optional(list(object({<br>        type = string<br>        port = number<br>      })))<br>      http_headers = optional(list(object({<br>        name  = string<br>        value = string<br>      })))<br>      source_addresses      = optional(list(string))<br>      source_ip_groups      = optional(list(string))<br>      destination_addresses = optional(list(string))<br>      destination_urls      = optional(list(string))<br>      destination_fqdns     = optional(list(string))<br>      destination_fqdn_tags = optional(list(string))<br>      terminate_tls         = optional(bool)<br>      web_categories        = optional(list(string))<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_network_rule_collection"></a> [network\_rule\_collection](#input\_network\_rule\_collection) | (Optional) The Network Rule Collection to use in this Firewall Policy Rule Collection Group. | <pre>list(object({<br>    name     = string<br>    action   = string<br>    priority = number<br>    rule = list(object({<br>      name                  = string<br>      description           = optional(string)<br>      protocols             = list(string)<br>      destination_ports     = list(string)<br>      source_addresses      = optional(list(string))<br>      source_ip_groups      = optional(list(string))<br>      destination_addresses = optional(list(string))<br>      destination_fqdns     = optional(list(string))<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_nat_rule_collection"></a> [nat\_rule\_collection](#input\_nat\_rule\_collection) | (Optional) The NAT Rule Collection to use in this Firewall Policy Rule Collection Group. | <pre>list(object({<br>    name     = string<br>    action   = string<br>    priority = number<br>    rule = list(object({<br>      name               = string<br>      description        = optional(string)<br>      protocols          = list(string)<br>      source_addresses   = optional(list(string))<br>      source_ip_groups   = optional(list(string))<br>      destination_ports  = optional(list(string))<br>      translated_address = optional(string)<br>      translated_port    = number<br>      translated_fqdn    = optional(string)<br>    }))<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_resource_group_id"></a> [resource\_group\_id](#output\_resource\_group\_id) | resource group id |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | resource group name |
| <a name="output_vnet_names"></a> [vnet\_names](#output\_vnet\_names) | Map of vnet names where key in input key in network map and value is name of vnet that got created. |
| <a name="output_vnet_ids"></a> [vnet\_ids](#output\_vnet\_ids) | Map of vnet names where key in input key in network map and value is id of vnet that got created. |
| <a name="output_vnet_subnets"></a> [vnet\_subnets](#output\_vnet\_subnets) | Map of vnet names where key in input key in network map and value is id of the subnets that got created. |
| <a name="output_vnet_locations"></a> [vnet\_locations](#output\_vnet\_locations) | Map of vnet names where key in input key in network map and value is location of vnet that got created. |
| <a name="output_vnet_address_spaces"></a> [vnet\_address\_spaces](#output\_vnet\_address\_spaces) | Map of vnet names where key in input key in network map and value is address of vnet that got created. |
| <a name="output_vnet_subnet_name_id_map"></a> [vnet\_subnet\_name\_id\_map](#output\_vnet\_subnet\_name\_id\_map) | Outputs a subnet name to ID map for each Vnet |
| <a name="output_firewall_ids"></a> [firewall\_ids](#output\_firewall\_ids) | Firewall generated ids |
| <a name="output_firewall_names"></a> [firewall\_names](#output\_firewall\_names) | Firewall names |
| <a name="output_firewall_private_ip_addresses"></a> [firewall\_private\_ip\_addresses](#output\_firewall\_private\_ip\_addresses) | Firewall private IPs |
| <a name="output_firewall_public_ip_addresses"></a> [firewall\_public\_ip\_addresses](#output\_firewall\_public\_ip\_addresses) | Firewall public IPs |
| <a name="output_firewall_subnet_ids"></a> [firewall\_subnet\_ids](#output\_firewall\_subnet\_ids) | IDs of the subnet attached to the firewall |
| <a name="output_firewall_policy_id"></a> [firewall\_policy\_id](#output\_firewall\_policy\_id) | The ID of the Firewall Policy. |
| <a name="output_firewall_policy_child_policies"></a> [firewall\_policy\_child\_policies](#output\_firewall\_policy\_child\_policies) | The child policies of the Firewall Policy. |
| <a name="output_firewall_policy_firewalls"></a> [firewall\_policy\_firewalls](#output\_firewall\_policy\_firewalls) | A list of references to Azure Firewalls that this Firewall Policy is associated with. |
| <a name="output_firewall_policy_rule_collection_groups"></a> [firewall\_policy\_rule\_collection\_groups](#output\_firewall\_policy\_rule\_collection\_groups) | A list of references to Azure Firewall Rule Collection Groups that this Firewall Policy is associated with. |
| <a name="output_firewall_policy_name"></a> [firewall\_policy\_name](#output\_firewall\_policy\_name) | The name of the Firewall Policy. |
| <a name="output_firewall_policy_rule_collection_group_name"></a> [firewall\_policy\_rule\_collection\_group\_name](#output\_firewall\_policy\_rule\_collection\_group\_name) | Value of the Azure Firewall policy rule collection group name |
| <a name="output_firewall_policy_rule_collection_group_id"></a> [firewall\_policy\_rule\_collection\_group\_id](#output\_firewall\_policy\_rule\_collection\_group\_id) | The ID of the Firewall Policy Rule Collection Group. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
