//variable "packet_auth_token" {
//  description = ""
//  type        = string
//}

provider "packet" {
  //  auth_token = var.packet_auth_token
  version = "~>2.3"
}

variable "public_key" {}
variable "private_key_path" {}

module "registration" {
  source            = "github.com/insight-icon/terraform-icon-packet-registration.git"
  details_endpoint  = "https://raw.githubusercontent.com/insight-icon/terraform-icon-packet-registration/master/test/fixtures/details.json"
  keystore_password = "testing1."
  keystore_path     = "${path.module}/../../test/fixtures/keystore/keystore-min-specs"
}

module "defaults" {
  source           = "../.."
  project_name     = "stuff"
  public_key       = var.public_key
  private_key_path = var.private_key_path
}
