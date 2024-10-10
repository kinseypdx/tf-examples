# Get Started with NR Terraform provider - sample code

### Prerequisites:
Terraform CLI

### Using this code:
1. Clone this repo and cd into the directory
2. You need to set up the NR provider for your account by setting two config settings that are imported via tf variables.
   - `touch terraform.tfvars`
   - in this file add two lines:
  ```
api_key    = "{your user API key}" # usually starts with "NRAK"
account_id = {your account id}
```
3. My account id is used in the dashboards json. You can just swap this out to your own.

### Terraform 
1. `terraform init` will set up Terraform to be ready to create a plan, which includes getting the NR Terraform provider as stated in the main.tf file
2. `terraform plan` - check out what will be created, if it looks good proceed to...
3. `terraform apply`  - you should now have a few things in your account: dashboards, synthetics, and alerts conditions and policies.
