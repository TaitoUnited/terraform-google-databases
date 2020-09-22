# Google Cloud databases

Example usage:

```
provider "google" {
  project             = "my-infrastructure"
  region              = "europe-west1"
  zone                = "europe-west1b"
}

resource "google_project_service" "compute" {
  service             = "compute.googleapis.com"
}

module "databases" {
  source              = "TaitoUnited/databases/google"
  version             = "1.0.0"
  depends_on          = [ google_project_service.compute ]

  postgresql_clusters = yamldecode(file("${path.root}/../infra.yaml"))["postgresqlClusters"]
  mysql_clusters      = yamldecode(file("${path.root}/../infra.yaml"))["mysqlClusters"]
  private_network_id  = module.network.database_network_id
}
```

Example YAML:

```
postgresqlClusters:
  - name: my-common-postgres
    region: europe-west1
    zone: europe-west1b
    version: POSTGRES_12
    tier: db-custom-1-3840
    maintenanceDay: 2
    maintenanceHour: 2
    backupStartTime: 05:00
    pointInTimeRecoveryEnabled: false
    highAvailabilityEnabled: true
    publicIpEnabled: false
    authorizedNetworks:
      - 127.127.127.127/32
    flags:
      log_min_duration_statement: 1000
    adminUsername: admin

mysqlClusters:
  - name: my-common-mysql
    region: europe-west1
    zone: europe-west1b
    version: MYSQL_8_0
    tier: db-custom-1-3840
    maintenanceDay: 2
    maintenanceHour: 2
    backupStartTime: 05:00
    pointInTimeRecoveryEnabled: false
    highAvailabilityEnabled: true
    publicIpEnabled: false
    authorizedNetworks:
      - 127.127.127.127/32
    adminUsername: admin
```

Combine with the following modules to get a complete infrastructure defined by YAML:

- [Admin](https://registry.terraform.io/modules/TaitoUnited/admin/google)
- [DNS](https://registry.terraform.io/modules/TaitoUnited/dns/google)
- [Network](https://registry.terraform.io/modules/TaitoUnited/network/google)
- [Kubernetes](https://registry.terraform.io/modules/TaitoUnited/kubernetes/google)
- [Databases](https://registry.terraform.io/modules/TaitoUnited/databases/google)
- [Storage](https://registry.terraform.io/modules/TaitoUnited/storage/google)
- [Monitoring](https://registry.terraform.io/modules/TaitoUnited/monitoring/google)
- [Events](https://registry.terraform.io/modules/TaitoUnited/events/google)
- [PostgreSQL privileges](https://registry.terraform.io/modules/TaitoUnited/privileges/postgresql)
- [MySQL privileges](https://registry.terraform.io/modules/TaitoUnited/privileges/mysql)

TIP: Similar modules are also available for AWS, Azure, and DigitalOcean. All modules are used by [infrastructure templates](https://taitounited.github.io/taito-cli/templates#infrastructure-templates) of [Taito CLI](https://taitounited.github.io/taito-cli/). See also [Google Cloud project resources](https://registry.terraform.io/modules/TaitoUnited/project-resources/google), [Full Stack Helm Chart](https://github.com/TaitoUnited/taito-charts/blob/master/full-stack), and [full-stack-template](https://github.com/TaitoUnited/full-stack-template).

Contributions are welcome!
