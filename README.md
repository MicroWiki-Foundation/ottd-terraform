# ottd-terraform

OpenTTD server setup via Terraform on Hetzner cloud. Provided as-is, purpose built for MicroWiki's OTTD game. If needed, can be expanded into a larger package eventually.

## Configuration

Configuration is based on the configuration from https://github.com/ropenttd/official-server-config.

Some configuration can be set up through parameters. This was purpose-built, so we don't really expose all of them in some meaningful way. If you need any, either add them and create a pull request, or just change them in the file directly.

If there is any demand, this could be expanded to provide a more fluent interface for parameters directly specified through terraform, but that's not on the books for now.

### tfvars

Currently, the supported tfvars are:

* `hcloud_token` - Hetzner cloud token. Since this is purposefuly built to run on Hetzner, it is required. If you wish to use a different provider, changing it should be easy.
* `ssh_public_key` - Public SSH key you wish to use to connect to the SSH server.
* `server_name` - Name of the server, as announced to the OTTD game coordinator. By default, number will be appended to it, if you wish to create multiple servers with the same template.
* `rcon_password` - RCON password
* `admin_password` - Admin password
* `openttd_version` - Version of the OpenTTD container.
* `map_x` - Size of the map in the X dimension, two to the power of x (for 1024, do 10)
* `map_y` - size of the map in the Y dimension, two to the power of y (for 1024, do 10)
* `water_borders` - Bitmask for water borders, for full water borders, use 15 (default)

If you create multiple servers, they will all use the same configuration variables. If you need that change, it should be fairly easy to make a map of configuration overrides for each server, but it is not added right now.

## Using this

Use `terraform apply -var-file .tfvars` to create a server, and `terraform destroy -var-file .tfvars` to destroy the server.

In roughly two minutes, the server should be ready to accept connections.