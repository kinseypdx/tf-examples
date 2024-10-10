variable "api_key" {}
variable "account_id" {}

terraform {
  required_version = "~> 1.0"
  required_providers {
    newrelic = {
      source  = "newrelic/newrelic"
      version = ">= 3.43.0, < 4.0.0"
    }
  }
}

# Configure the New Relic provider
provider "newrelic" {
  account_id = var.account_id
  api_key    = var.api_key # usually prefixed with 'NRAK'
  region     = "US"        # Valid regions are US and EU
}


