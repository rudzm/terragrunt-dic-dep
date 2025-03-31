resource "null_resource" "example" {
  provisioner "local-exec" {
    command = "echo This command will execute whenever the configuration of cloudsql changes on ${var.env} environment"
  }
}

data "google_projects" "project" {
  filter = "name:${var.project_name}"
}

module "gke" {
  source = "cluster@v0.4.2"


  name                       = "mrudz-sandbox-gke-1"
  project_id                 = data.google_projects.project.projects[0].project_id
  region                     = var.region
  zones                      = var.zones
  svpc_name                  = var.svpc_name
  svpc_host_project          = var.svpc_host_project
  root_network_prefix        = var.root_network_prefix
  gke_masters_network_prefix = var.gke_masters_network_prefix
  gar_project                = var.gar_project
  gke_authorized_networks    = var.gke_authorized_networks
  cluster_size               = "small"
  node_pools = [
    {
      name               = "node-pool-1"
      machine_type       = "n2-standard-4"
      min_count          = 1
      initial_node_count = 1
      max_count          = 1
    }
  ]
}