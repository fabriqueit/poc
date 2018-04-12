provider "google" {
  credentials = "${file("account.json")}"
  project = "TestKub1"
  region = "europe-west1"
}

module "gce-dc" {
  source = "./providers/gce"
  datacenter = "gce-dc"
  cluster_type = "n1-standard-2"
  cluster_size = "6"
  network_ipv4 = "10.0.0.0/16"
  name = "rke_cluster"
  short_name = "rke"
  region = ""
  zone = ""
}

output "masters_ips" {
    value = "{\"private_ip\": [\"${join("\",\"", module.gce-dc.masters_private_ips)}\"], \"public_ip\": [\"${join("\",\"", module.gce-dc.masters_public_ips)}\"]}"
}

output "workers_ips" {
    value = "{\"private_ip\": [\"${join("\",\"", module.gce-dc.workers_private_ips)}\"], \"public_ip\": [\"${join("\",\"", module.gce-dc.workers_public_ips)}\"]}"
}
