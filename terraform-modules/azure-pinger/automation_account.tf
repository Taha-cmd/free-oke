resource "azurerm_resource_group" "resource_group" {
  name     = "automation-rg"
  location = var.location
}

resource "azurerm_automation_account" "automation_account" {
  name                = "automation-aa"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.location
  sku_name            = "Free"
}

resource "azurerm_automation_schedule" "ping_schedule" {
  name                    = "ping-schedule"
  resource_group_name     = azurerm_resource_group.resource_group.name
  automation_account_name = azurerm_automation_account.automation_account.name
  description             = "Ping oke cluster to generate network traffic"
  start_time              = timeadd(timestamp(), "10m")

  # Azure grants 500 minutes of job runtime in the free tier https://azure.microsoft.com/en-us/pricing/free-services
  # Assuming that a job would take 1 minute to complete, we can run 500 / 31 = 16,12 ~= 16 jobs a day, once every
  # 24 / 16 = 1,5 ~= 2 hours
  frequency = "Hour"
  interval  = 2
}

resource "azurerm_automation_runbook" "ping_oke_cluster" {
  name                    = "ping-oke-cluster"
  automation_account_name = azurerm_automation_account.automation_account.name
  resource_group_name     = azurerm_resource_group.resource_group.name
  location                = var.location
  runbook_type            = "PowerShell" # Terraform can't create pwsh 7 types, see https://github.com/hashicorp/terraform-provider-azurerm/issues/14089
  log_progress            = false
  log_verbose             = true
  content                 = file("${path.module}/Ping-Target.ps1")
  description             = "Ping oke cluster to generate network traffic"
}

resource "azurerm_automation_job_schedule" "ping_oke_cluster_job_schedule" {
  resource_group_name     = azurerm_resource_group.resource_group.name
  automation_account_name = azurerm_automation_account.automation_account.name
  runbook_name            = azurerm_automation_runbook.ping_oke_cluster.name
  schedule_name           = azurerm_automation_schedule.ping_schedule.name

  parameters = {
    target = data.terraform_remote_state.k8s.outputs.load_balancer_ip
    count  = 10
  }
}
