locals {
  # Automatically load cloud-level variables
  cloud_vars = read_terragrunt_config(find_in_parent_folders("cloud.hcl", "cloud.hcl"), { locals = {} })

  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl", "env.hcl"), { locals = {} })

  # Team 
  team_vars = read_terragrunt_config(find_in_parent_folders("team.hcl", "team.hcl"), { locals = {} })
}


inputs = merge(
  local.cloud_vars.locals,
  local.environment_vars.locals,
  local.team_vars.locals
)

