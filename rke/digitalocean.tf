provider "digitalocean" {
# You need to set this in your .bashrc
# export DIGITALOCEAN_TOKEN="Your API TOKEN"
#
}

module "do-hosts" {
  source = "./providers/digitalocean"
  ssh_key = "7f:d4:c0:76:ca:9c:ae:b2:16:e7:8a:93:7d:d2:1f:a9"
}

output "masters_ips" {
    value = "{\"private_ip\": [\"${join("\",\"", module.do-hosts.masters_private_ips)}\"], \"public_ip\": [\"${join("\",\"", module.do-hosts.masters_public_ips)}\"]}"
}

output "workers_ips" {
    value = "{\"private_ip\": [\"${join("\",\"", module.do-hosts.workers_private_ips)}\"], \"public_ip\": [\"${join("\",\"", module.do-hosts.workers_public_ips)}\"]}"
}
