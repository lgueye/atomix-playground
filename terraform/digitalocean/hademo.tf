# droplets specs
variable "droplet_image" {
  default = "ubuntu-18-04-x64"
}
variable "primary_datacenter_name" {
  default = "fra1"
}
variable "fallback_datacenter_name" {
  default = "ams3"
}
variable "ternary_datacenter_name" {
  default = "lon1"
}
variable "primary_datacenter_role" {
  default = "primary"
}
variable "fallback_datacenter_role" {
  default = "fallback"
}
variable "ternary_datacenter_role" {
  default = "ternary"
}
variable "droplet_size" {
  default = "1gb"
}

# target environment
resource "digitalocean_tag" "target_env" {
  name = "${var.target_env}"
}

# ansible vars
variable "ansible_python_interpreter" {
  default = "/usr/bin/python3"
}

# consul cluster vars
variable "consul_client_role" {
  default = "consul-client"
}
variable "consul_server_role" {
  default = "consul-server"
}

resource "digitalocean_tag" "consul_client_role" {
  name = "${var.consul_client_role}"
}
resource "digitalocean_tag" "consul_server_role" {
  name = "${var.consul_server_role}"
}

# cockroachdb cluster vars
variable "cockroachdb_server_role" {
  default = "cockroachdb-server"
}
variable "cockroachdb_master_role" {
  default = "cockroachdb-master"
}
resource "digitalocean_tag" "cockroachdb_server_role" {
  name = "${var.cockroachdb_server_role}"
}
resource "digitalocean_tag" "cockroachdb_master_role" {
  name = "${var.cockroachdb_master_role}"
}

# consumer service cluster vars
variable "service_name" {
  default = "sos"
}
resource "digitalocean_tag" "service_name" {
  name = "${var.service_name}"
}

# lb vars
variable "lb_name" {
  default = "lb"
}
resource "digitalocean_tag" "lb_name" {
  name = "${var.lb_name}"
}

resource "digitalocean_droplet" "consul_server_01_droplet" {
  image = "${var.droplet_image}"
  name = "${var.consul_server_role}-01"
  region = "${var.primary_datacenter_name}"
  size = "${var.droplet_size}"
  private_networking = true
  ssh_keys = ["${var.ssh_fingerprint}"]
  tags = ["${digitalocean_tag.target_env.name}","${digitalocean_tag.consul_server_role.name}"]
}
resource "ansible_host" "consul_server_01_droplet" {
    inventory_hostname = "${digitalocean_droplet.consul_server_01_droplet.name}"
    groups = ["${var.target_env}","${var.consul_server_role}","${var.primary_datacenter_role}"]
    vars {
      ansible_host = "${digitalocean_droplet.consul_server_01_droplet.ipv4_address}"
      ansible_python_interpreter = "${var.ansible_python_interpreter}"
      datacenter_name = "${var.primary_datacenter_name}"
      datacenter_role = "${var.primary_datacenter_role}"
    }
}
resource "digitalocean_droplet" "consul_server_02_droplet" {
  image = "${var.droplet_image}"
  name = "${var.consul_server_role}-02"
  region = "${var.fallback_datacenter_name}"
  size = "${var.droplet_size}"
  private_networking = true
  ssh_keys = ["${var.ssh_fingerprint}"]
  tags = ["${digitalocean_tag.target_env.name}","${digitalocean_tag.consul_server_role.name}"]
}
resource "ansible_host" "consul_server_02_droplet" {
    inventory_hostname = "${digitalocean_droplet.consul_server_02_droplet.name}"
    groups = ["${var.target_env}","${var.consul_server_role}","${var.fallback_datacenter_role}"]
    vars {
      ansible_host = "${digitalocean_droplet.consul_server_02_droplet.ipv4_address}"
      ansible_python_interpreter = "${var.ansible_python_interpreter}"
      datacenter_name = "${var.fallback_datacenter_name}"
      datacenter_role = "${var.fallback_datacenter_role}"
    }
}
resource "digitalocean_droplet" "consul_server_03_droplet" {
  image = "${var.droplet_image}"
  name = "${var.consul_server_role}-03"
  region = "${var.ternary_datacenter_name}"
  size = "${var.droplet_size}"
  private_networking = true
  ssh_keys = ["${var.ssh_fingerprint}"]
  tags = ["${digitalocean_tag.target_env.name}","${digitalocean_tag.consul_server_role.name}"]
}
resource "ansible_host" "consul_server_03_droplet" {
    inventory_hostname = "${digitalocean_droplet.consul_server_03_droplet.name}"
    groups = ["${var.target_env}","${var.consul_server_role}","${var.ternary_datacenter_role}"]
    vars {
      ansible_host = "${digitalocean_droplet.consul_server_03_droplet.ipv4_address}"
      ansible_python_interpreter = "${var.ansible_python_interpreter}"
      datacenter_role = "${var.ternary_datacenter_role}"
      datacenter_name = "${var.ternary_datacenter_name}"
    }
}

# cockroachdb droplets and ansible inventory
resource "digitalocean_droplet" "cockroachdb_server_01_droplet" {
  image = "${var.droplet_image}"
  name = "${var.cockroachdb_server_role}-01"
  region = "${var.primary_datacenter_name}"
  size = "${var.droplet_size}"
  private_networking = true
  ssh_keys = ["${var.ssh_fingerprint}"]
  tags = ["${digitalocean_tag.target_env.name}","${digitalocean_tag.cockroachdb_server_role.name}","${digitalocean_tag.consul_client_role.name}","${digitalocean_tag.cockroachdb_master_role.name}"]
}
resource "ansible_host" "cockroachdb_server_01_droplet" {
  inventory_hostname = "${digitalocean_droplet.cockroachdb_server_01_droplet.name}"
  groups = ["${var.target_env}","${var.consul_client_role}","${var.cockroachdb_server_role}","${var.cockroachdb_master_role}","${var.primary_datacenter_role}"]
  vars {
    ansible_host = "${digitalocean_droplet.cockroachdb_server_01_droplet.ipv4_address}"
    ansible_python_interpreter = "${var.ansible_python_interpreter}"
    datacenter_name = "${var.primary_datacenter_name}"
    datacenter_role = "${var.primary_datacenter_role}"
  }
}
resource "digitalocean_droplet" "cockroachdb_server_02_droplet" {
  image = "${var.droplet_image}"
  name = "${var.cockroachdb_server_role}-02"
  region = "${var.fallback_datacenter_name}"
  size = "${var.droplet_size}"
  private_networking = true
  ssh_keys = ["${var.ssh_fingerprint}"]
  tags = ["${digitalocean_tag.target_env.name}","${digitalocean_tag.consul_client_role.name}","${digitalocean_tag.cockroachdb_server_role.name}"]
}
resource "ansible_host" "cockroachdb_server_02_droplet" {
  inventory_hostname = "${digitalocean_droplet.cockroachdb_server_02_droplet.name}"
  groups = ["${var.target_env}","${var.consul_client_role}","${var.cockroachdb_server_role}","${var.fallback_datacenter_role}"]
  vars {
    ansible_host = "${digitalocean_droplet.cockroachdb_server_02_droplet.ipv4_address}"
    ansible_python_interpreter = "${var.ansible_python_interpreter}"
    datacenter_name = "${var.fallback_datacenter_name}"
    datacenter_role = "${var.fallback_datacenter_role}"
  }
}
resource "digitalocean_droplet" "cockroachdb_server_03_droplet" {
  image = "${var.droplet_image}"
  name = "${var.cockroachdb_server_role}-03"
  region = "${var.ternary_datacenter_name}"
  size = "${var.droplet_size}"
  private_networking = true
  ssh_keys = ["${var.ssh_fingerprint}"]
  tags = ["${digitalocean_tag.target_env.name}","${digitalocean_tag.consul_client_role.name}","${digitalocean_tag.cockroachdb_server_role.name}"]
}
resource "ansible_host" "cockroachdb_server_03_droplet" {
  inventory_hostname = "${digitalocean_droplet.cockroachdb_server_03_droplet.name}"
  groups = ["${var.target_env}","${var.consul_client_role}","${var.cockroachdb_server_role}","${var.ternary_datacenter_role}"]
  vars {
    ansible_host = "${digitalocean_droplet.cockroachdb_server_03_droplet.ipv4_address}"
    ansible_python_interpreter = "${var.ansible_python_interpreter}"
    datacenter_role = "${var.ternary_datacenter_role}"
    datacenter_name = "${var.ternary_datacenter_name}"
  }
}

# consumer service droplets and ansible inventory
resource "digitalocean_droplet" "service_01_droplet" {
  image = "${var.droplet_image}"
  name = "${var.service_name}-01"
  region = "${var.primary_datacenter_name}"
  size = "${var.droplet_size}"
  private_networking = true
  ssh_keys = ["${var.ssh_fingerprint}"]
  tags = ["${digitalocean_tag.target_env.name}","${digitalocean_tag.consul_client_role.name}","${digitalocean_tag.service_name.name}"]
}
resource "ansible_host" "service_01_droplet" {
  inventory_hostname = "${digitalocean_droplet.service_01_droplet.name}"
  groups = ["${var.target_env}","${var.consul_client_role}","${var.service_name}","${var.primary_datacenter_role}"]
  vars {
    ansible_host = "${digitalocean_droplet.service_01_droplet.ipv4_address}"
    ansible_python_interpreter = "${var.ansible_python_interpreter}"
    datacenter_name = "${var.primary_datacenter_name}"
    datacenter_role = "${var.primary_datacenter_role}"
  }
}
resource "digitalocean_droplet" "service_02_droplet" {
  image = "${var.droplet_image}"
  name = "${var.service_name}-02"
  region = "${var.fallback_datacenter_name}"
  size = "${var.droplet_size}"
  private_networking = true
  ssh_keys = ["${var.ssh_fingerprint}"]
  tags = ["${digitalocean_tag.target_env.name}","${digitalocean_tag.consul_client_role.name}","${digitalocean_tag.service_name.name}"]
}
resource "ansible_host" "service_02_droplet" {
  inventory_hostname = "${digitalocean_droplet.service_02_droplet.name}"
  groups = ["${var.target_env}","${var.consul_client_role}","${var.service_name}","${var.fallback_datacenter_role}"]
  vars {
    ansible_host = "${digitalocean_droplet.service_02_droplet.ipv4_address}"
    ansible_python_interpreter = "${var.ansible_python_interpreter}"
    datacenter_name = "${var.fallback_datacenter_name}"
    datacenter_role = "${var.fallback_datacenter_role}"
  }
}

# lb droplets and ansible inventory
resource "digitalocean_droplet" "lb_01_droplet" {
  image = "${var.droplet_image}"
  name = "${var.lb_name}-01"
  region = "${var.primary_datacenter_name}"
  size = "${var.droplet_size}"
  private_networking = true
  ssh_keys = ["${var.ssh_fingerprint}"]
  tags = ["${digitalocean_tag.target_env.name}","${digitalocean_tag.consul_client_role.name}","${digitalocean_tag.lb_name.name}"]
}
resource "ansible_host" "lb_01_droplet" {
  inventory_hostname = "${digitalocean_droplet.lb_01_droplet.name}"
  groups = ["${var.target_env}","${var.consul_client_role}","${var.lb_name}","${var.primary_datacenter_role}"]
  vars {
    ansible_host = "${digitalocean_droplet.lb_01_droplet.ipv4_address}"
    ansible_python_interpreter = "${var.ansible_python_interpreter}"
    datacenter_role = "${var.primary_datacenter_role}"
    datacenter_name = "${var.primary_datacenter_name}"
  }
}
resource "digitalocean_droplet" "lb_02_droplet" {
  image = "${var.droplet_image}"
  name = "${var.lb_name}-02"
  region = "${var.fallback_datacenter_name}"
  size = "${var.droplet_size}"
  private_networking = true
  ssh_keys = ["${var.ssh_fingerprint}"]
  tags = ["${digitalocean_tag.target_env.name}","${digitalocean_tag.consul_client_role.name}","${digitalocean_tag.lb_name.name}"]
}
resource "ansible_host" "lb_02_droplet" {
  inventory_hostname = "${digitalocean_droplet.lb_02_droplet.name}"
  groups = ["${var.target_env}","${var.consul_client_role}","${var.lb_name}","${var.fallback_datacenter_role}"]
  vars {
    ansible_host = "${digitalocean_droplet.lb_02_droplet.ipv4_address}"
    ansible_python_interpreter = "${var.ansible_python_interpreter}"
    datacenter_role = "${var.fallback_datacenter_role}"
    datacenter_name = "${var.fallback_datacenter_name}"
  }
}
