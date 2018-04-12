# RKE deployment

Rancher Kubernetes Engine deployment with `terraform` for automated infrastructure provisioning and `ansible` for software deployments. The installations are based on `RKE 0.1.1` the latest released version.

The goal of the repository is to make it as easy as possible for anyone to setup a kubernetes cluster using RKE on the providers below. If you would like support for any other provider, feel free to create a pull request.

Currently, the installation supports the following list of providers.

- [x] Digital Ocean
- [x] GCE
- [ ] AWS
- [ ] OpenStack

## Installation

To get started, review and modify the configuration in the files below as required. See the provider installation docs below for further information.

```shell
ansible.cfg
providers/<provider>.sample.tf
```

- [x] [Digital Ocean Installation Documentation](docs/digitalocean.md)
- [x] [Google Compute Engine Installation Documentation](docs/gce.md)

### Bootstrapping

Once the MariaDB Galera cluster has been created, you'll need to bootstrap the cluster by following the [Bootstrapping](docs/bootstrapping.md) documentation.

## Contributing

- Fork it (https://github.com/ldejager/mariadb-galera-cluster/fork)
- Create your feature branch (git checkout -b feature/new_feature)
- Commit your changes (git commit -am 'Added some new features')
- Push to the branch (git push origin feature/new_feature)
- Create a new Pull Request
