resource "null_resource" "example" {
  provisioner "local-exec" {
    command = "echo This command will execute whenever the configuration of cloudsql changes on ${var.env} environment"
  }
}