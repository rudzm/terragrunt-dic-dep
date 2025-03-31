# Common TF vars on team level

locals {
 project_name = "${basename(get_terragrunt_dir())}"
 region       = ""
 zones        = []
}