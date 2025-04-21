logical_product_service = "hub"
logical_product_family  = "launch"
class_env               = "sandbox"
instance_env            = 0
instance_resource       = 0
location                = "eastus"
resource_names_map = {
  resource_group = {
    name       = "rg"
    max_length = 80
  }
  hub_vnet = {
    name       = "vnet"
    max_length = 80
  }
  firewall = {
    name       = "fw"
    max_length = 80
  }
  firewall_policy = {
    name       = "fwplcy"
    max_length = 80
  }
  fw_plcy_rule_colln_grp = {
    name       = "fwplcyrulecollngrp"
    max_length = 80
  }
  public_ip = {
    name       = "pip"
    max_length = 80
  }
  hub_vnet_ip_configuration = {
    name       = "ipconfig"
    max_length = 80
  }
  custom_diagnostic_settings = {
    name       = "fwdiag"
    max_length = 80
  }
  log_analytics_workspace = {
    name       = "law"
    max_length = 80
  }
  monitor_diagnostic_setting = {
    name       = "fwds"
    max_length = 80
  }
}
network = {
  location            = "eastus"
  resource_group_name = "rg"
  vnet_name           = "vnet"
  address_space       = ["10.0.0.0/16"]
  subnets = {
    subnet-1 = {
      prefix = "10.0.1.0/24"
    }
  }
  bgp_community        = null
  ddos_protection_plan = null
  dns_servers          = []
  tags                 = {}
}

firewall = {
  logs_destinations_ids = []
  subnet_cidr           = "10.0.1.0/24"
  additional_public_ips = []
  sku_tier              = "Standard"
}

firewall_policy_rule_collection_group_priority = 100
application_rule_collection                    = []
network_rule_collection = [
  {
    name     = "network-filter-collection"
    action   = "Allow"
    priority = 200
    rule = [
      {
        name                  = "allowhttps-ib-ntc"
        source_addresses      = ["*"]
        destination_ports     = ["443"]
        destination_addresses = ["172.16.1.0/24"] //module to be deployed after spokes are ready
        protocols             = ["TCP"]
      },
      {
        name                  = "allowhttps-ob-ntc"
        source_addresses      = ["172.16.1.0/24"]
        destination_ports     = ["443"]
        destination_addresses = ["*"]
        protocols             = ["TCP"]
    }]
  }
]
nat_rule_collection = [
  {
    name     = "nat-rule-collection"
    action   = "Dnat"
    priority = 100
    rule = [
      {
        name               = "allowrdp-ib-nc"
        description        = "allowrdp-ib-nc"
        protocols          = ["TCP"]
        source_addresses   = ["*"]
        destination_ports  = ["3389"]
        translated_address = "172.16.1.4"
        translated_port    = "3389"
      },
      {
        name               = "allowhttp-ib-nc"
        description        = "allowhttp-ib-nc"
        protocols          = ["TCP"]
        source_addresses   = ["*"]
        destination_ports  = ["8080"]
        translated_address = "172.16.1.4"
        translated_port    = "8080"
      }
    ]
  }
]
