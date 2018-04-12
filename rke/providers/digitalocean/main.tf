variable region_name {  default = "fra1" }
variable image_name {  default = "rancheros" }
variable masters_size { default = 3 }
variable workers_size { default = 3 }
variable cluster_memory_size { default = "4gb" }
variable short_hostname { default = "rke" }
variable ssh_key { default = "" }

# Create a new db Droplet in the fra1 region
resource "digitalocean_droplet" "rke-masters" {
  image  = "${var.image_name}"
  region = "${var.region_name}"
  name = "${var.short_hostname}-masters-${format("%02d", count.index+1)}"
  private_networking = "true"
  size = "${var.cluster_memory_size}"
  ssh_keys = ["${var.ssh_key}"]
  user_data = "${ file("./providers/digitalocean/cloud-config") }"
  count = "${var.masters_size}"
}

# Create a new db Droplet in the fra1 region
resource "digitalocean_droplet" "rke-workers" {
  image  = "${var.image_name}"
  region = "${var.region_name}"
  name = "${var.short_hostname}-workers-${format("%02d", count.index+1)}"
  private_networking = "true"
  size = "${var.cluster_memory_size}"
  ssh_keys = ["${var.ssh_key}"]
  user_data = "${ file("./providers/digitalocean/cloud-config") }"
  count = "${var.workers_size}"
}

output "masters_private_ips" {
  value = ["${digitalocean_droplet.rke-masters.*.ipv4_address_private}"]
}

output "masters_public_ips" {
  value = ["${digitalocean_droplet.rke-masters.*.ipv4_address}"]
}

output "workers_private_ips" {
  value = ["${digitalocean_droplet.rke-workers.*.ipv4_address_private}"]
}

output "workers_public_ips" {
  value = ["${digitalocean_droplet.rke-workers.*.ipv4_address}"]
}
