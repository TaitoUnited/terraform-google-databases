/**
 * Copyright 2020 Taito United
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

resource "google_sql_database_instance" "postgres" {
  # TODO: not required?
  # depends_on = [google_service_networking_connection.private_vpc_connection]

  count = length(local.postgresqlClusters)
  name  = local.postgresqlClusters[count.index].name

  database_version = local.postgresqlClusters[count.index].version
  region           = local.postgresqlClusters[count.index].region

  settings {
    tier              = local.postgresqlClusters[count.index].tier
    availability_type = local.postgresqlClusters[count.index].highAvailabilityEnabled ? "REGIONAL" : "ZONAL"

    location_preference {
      zone = local.postgresqlClusters[count.index].zone
    }

    ip_configuration {
      ipv4_enabled    = local.postgresqlClusters[count.index].publicIpEnabled ? true : false
      private_network = var.private_network_id
      require_ssl     = "true"

      dynamic "authorized_networks" {
        for_each = local.postgresqlClusters[count.index].authorizedNetworks != null ? local.postgresqlClusters[count.index].authorizedNetworks : []
        content {
          value = authorized_networks.value
        }
      }
    }

    dynamic "database_flags" {
      for_each = local.postgresqlClusters[count.index].flags
      content {
        name                = database_flags.key
        value               = database_flags.value
      }
    }

    maintenance_window {
      day          = local.postgresqlClusters[count.index].maintenanceDay
      hour         = local.postgresqlClusters[count.index].maintenanceHour
      update_track = "stable"
    }

    backup_configuration {
      enabled    = "true"
      start_time = local.postgresqlClusters[count.index].backupStartTime
      point_in_time_recovery_enabled = local.postgresqlClusters[count.index].pointInTimeRecoveryEnabled
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}
