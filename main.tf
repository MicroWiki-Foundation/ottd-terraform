# Tell Terraform to include the hcloud provider
terraform {
    required_providers {
        hcloud = {
        source  = "hetznercloud/hcloud"
        # Here we use version 1.48.0, this may change in the future
        version = "1.48.0"
        }
    }
}

# Declare the hcloud_token variable from .tfvars
variable "hcloud_token" {
    sensitive = true # Requires terraform >= 0.14
}

variable "ssh_public_key" {
    type = string
    sensitive = false
}

# OpenTTD Settings

variable "openttd_version" {
    type = string
    default = "14.1"
}

# The map size in X direction (x to the power of...)
variable "map_x" {
    type = number
    default = 11
}

# The map size in Y direction (y to the power of...)
variable "map_y" {
    type = number
    default = 11
}

# Bitmask
variable "water_borders" {
    type = number
    default = 15 # 15 = all borders are water
}

variable "rcon_password" {
    type = string
    sensitive = false
}

variable "admin_password" {
    type = string
    sensitive = false
}

variable "server_name" {
    type = string
}

# Configure the Hetzner Cloud Provider with your token
provider "hcloud" {
    token = var.hcloud_token
}

locals {
    template = templatefile("${path.module}/ottd-cloudinit.yaml.tftpl", {
        ssh_public_key = var.ssh_public_key,

        openttd_config = "${indent(6, templatefile("${path.module}/openttd.cfg.tftpl", {
            server_name = "${var.server_name} 1",
            rcon_password = var.rcon_password,
            admin_password = var.admin_password,
            
            map_x = var.map_x,
            map_y = var.map_y,
            water_borders = var.water_borders
        }))}",

        docker_compose = "${indent(6, templatefile("${path.module}/docker-compose.yaml.tftpl", {
            openttd_version = var.openttd_version
        }))}"
    })
}

#resource "local_file" "template" {
#    content  = local.template
#    filename = "cloudinit.yaml"
#}

resource "hcloud_server" "ottd-servers" {
    count = 1
    
    name        = "ottd-server-${count.index}"
    image       = "debian-12"
    server_type = "cx22"
    location    = "fsn1"
    public_net {
        ipv4_enabled = true
        ipv6_enabled = true
    }

    user_data = local.template
}
output "server_ip" {
    value = hcloud_server.ottd-servers.0.ipv4_address
}