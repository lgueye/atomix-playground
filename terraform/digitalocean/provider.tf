variable "do_token" {}
variable "pub_key" {}
variable "pvt_key" {}
variable "ssh_fingerprint" {}
variable "target_env" {}

provider "digitalocean" {
  token = "${var.do_token}"
}
