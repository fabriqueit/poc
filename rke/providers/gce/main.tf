variable "cluster_type" {default = "n1-standard-1"}
variable "masters_size" {default = 3}
variable "workers_size" {default = 3}
variable "cluster_volume_size" {default = "20"} # GB
variable "cluster_data_volume_size" {default = "20"} # GB
variable "datacenter" {default = "gce"}
variable "name" {default = "rke-cluster"}
variable "network_ipv4" {default = "10.0.0.0/16"}
variable "region" {default = "europe-west1"}
variable "short_name" {default = "rke"}
variable "ssh_key" {default = "~/.ssh/id_rsa.pub"}
variable "ssh_user" {default = "ubuntu"}
variable "zone" {default = "europe-west1-b"}

# Network
resource "google_compute_network" "rke-network" {
  name = "${var.name}"
}

resource "google_compute_subnetwork" "rke-subnetwork" {
  name          = "${var.name}-${var.region}"
  ip_cidr_range = "${var.network_ipv4}"
  network       = "${google_compute_network.rke-network.self_link}"
  region        = "${var.region}"
}

# Firewall
resource "google_compute_firewall" "rke-firewall-ext" {
  name = "${var.short_name}-firewall-ext"
  network = "${google_compute_network.rke-network.name}"
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports = [
      "22",     # SSH
      "6443",   # Kubernetes kubectl
      "10250"   # used by helm
    ]
  }
}

resource "google_compute_firewall" "rke-firewall-int" {
  name = "${var.short_name}-firewall-int"
  network = "${google_compute_network.rke-network.name}"
  source_ranges = ["${var.network_ipv4}"]

  allow {
    protocol = "tcp"
    ports = ["1-65535"]
  }

  allow {
    protocol = "udp"
    ports = ["1-65535"]
  }
}

# Instances
resource "google_compute_instance" "rke-masters-nodes" {
  name = "${var.short_name}-masters-${format("%02d", count.index+1)}"
  description = "${var.name} master node #${format("%02d", count.index+1)}"
  machine_type = "${var.cluster_type}"
  zone = "${var.zone}"
  can_ip_forward = false
  tags = ["${var.short_name}", "rke-cluster"]

  boot_disk {
    initialize_params {
      image = "ubuntu-1604-lts"
      size = "${var.cluster_volume_size}"
    }
    auto_delete = true
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.rke-subnetwork.name}"
    access_config {}
  }

  metadata {
    dc = "${var.datacenter}"
    role = "rke-host"
    sshKeys = "${var.ssh_user}:${file(var.ssh_key)} ${var.ssh_user}"
    ssh_user = "${var.ssh_user}"
  }

  scheduling {
    preemptible = true
  }

  metadata_startup_script = "${ file("./providers/gce/install-docker.sh") }"

  count = "${var.masters_size}"
}

resource "google_compute_instance" "rke-workers-nodes" {
  name = "${var.short_name}-worker-${format("%02d", count.index+1)}"
  description = "${var.name} worker node #${format("%02d", count.index+1)}"
  machine_type = "${var.cluster_type}"
  zone = "${var.zone}"
  can_ip_forward = false
  tags = ["${var.short_name}", "rke-cluster"]

  boot_disk {
    initialize_params {
      image = "ubuntu-1604-lts"
      size = "${var.cluster_volume_size}"
    }
    auto_delete = true
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.rke-subnetwork.name}"
    access_config {}
  }

  metadata {
    dc = "${var.datacenter}"
    role = "rke-host"
    sshKeys = "${var.ssh_user}:${file(var.ssh_key)} ${var.ssh_user}"
    ssh_user = "${var.ssh_user}"
  }

  scheduling {
    preemptible = true
  }

  metadata_startup_script = "${ file("./providers/gce/install-docker.sh") }"

  count = "${var.workers_size}"
}

output "masters_private_ips" {
  value = ["${google_compute_instance.rke-masters-nodes.*.network_interface.0.address}"]
}

output "masters_public_ips" {
  value = ["${google_compute_instance.rke-masters-nodes.*.network_interface.0.access_config.0.assigned_nat_ip}"]
}

output "workers_private_ips" {
  value = ["${google_compute_instance.rke-workers-nodes.*.network_interface.0.address}"]
}

output "workers_public_ips" {
  value = ["${google_compute_instance.rke-workers-nodes.*.network_interface.0.access_config.0.assigned_nat_ip}"]
}
