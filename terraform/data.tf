data "terraform_remote_state" "example" {
  backend = "http"

  config = {
    address = var.address
    username = var.username
    password = var.password
  }
}