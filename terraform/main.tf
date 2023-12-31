data "azurerm_client_config" "current" {}

module "resource_group" {
  source                                      = "github.com/techslateramu/terraform-modules//azure/resourcegroup"
  environment                                 = var.env
  location                                    = var.location
  main_project                                = var.main_project
  sub_project                                 = var.sub_project
  tags                                        = merge(var.tags, var.specific_tags)
}

module "key_vault" {
  source                                      = "github.com/techslateramu/terraform-modules//azure/keyvault"
  location                                    = var.location
  environment                                 = var.env
  main_project                                = var.main_project
  sub_project                                 = var.sub_project
  resource_group_name                         = module.resource_group.name
  tenant_id                                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days                  = var.soft_delete_retention_days
  access_policy                               = local.kv_access_policy
  tags                                        = merge(var.tags, var.specific_tags)
}

module "app_service_plan" {
  source                                      = "github.com/techslateramu/terraform-modules//azure/appserviceplan"
  environment                                 = var.env
  main_project                                = var.main_project
  sub_project                                 = var.sub_project
  location                                    = var.location
  resource_group_name                         = module.resource_group.name
  asp_sku_size                                = var.asp_sku_size
  asp_os_type                                 = var.asp_os_type  
  tags                                        = merge(var.tags, var.specific_tags)
}

module "windows_web_app" {
  source                                  = "github.com/techslateramu/terraform-modules//azure/windowswebapp"
  resource_group_name                     = module.resource_group.name
  location                                = var.location
  environment                             = var.env
  service_plan_id                         = module.app_service_plan.app_service_id
  main_project                            = var.main_project
  sub_project                             = var.sub_project
  tags                                    = merge(var.tags, var.specific_tags)
  identity                                = local.identity
  connection_string                       = local.connection_string
  site_config                             = local.site_config
  app_settings                            = local.app_settings
}

module "application_insights" {
  source                                      = "github.com/techslateramu/terraform-modules//azure/appinsights"
  location                                    = var.location
  resource_group_name                         = module.resource_group.name
  environment                                 = var.env
  main_project                                = var.main_project
  sub_project                                 = var.sub_project

  application_type                            = var.app_in_application_type
  daily_data_cap_in_gb                        = var.app_in_daily_data_cap_in_gb
  daily_data_cap_notifications_disabled       = var.app_in_daily_data_cap_notifications_disabled
  retention_in_days                           = var.app_in_retention_in_days
  disable_ip_masking                          = var.app_in_disable_ip_masking
  workspace_id                              = module.analytics_workspace.id
  tags                                        = merge(var.tags, var.specific_tags)
}

module "analytics_workspace" {
  source                                      = "github.com/techslateramu/terraform-modules//azure/loganalyticsworkspace"
  location                                    = var.location
  resource_group_name                         = module.resource_group.name
  environment                                 = var.env
  main_project                                = var.main_project
  sub_project                                 = var.sub_project
  tags                                        = var.tags
}
