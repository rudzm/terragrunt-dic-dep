
include "root" {
  path = find_in_parent_folders("root.hcl")
}

inputs = {
  project_name = "${basename(get_terragrunt_dir())}"
}