/**
 * Copyright 2021 Taito United
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

  for_each = {for item in local.postgresqlClusters: item.name => item}
  name     = each.value.name

  database_version = each.value.version
  region           = each.value.region

  settings {
    tier              = each.value.tier
    availability_type = each.value.highAvailabilityEnabled ? "REGIONAL" : "ZONAL"

    location_preference {
      zone = each.value.zone
    }

    ip_configuration {
      ipv4_enabled    = each.value.publicIpEnabled ? true : false
      private_network = var.private_network_id
      ssl_mode        = "TRUSTED_CLIENT_CERTIFICATE_REQUIRED"
      require_ssl     = true # TODO: remove this when the google provider is updated

      dynamic "authorized_networks" {
        for_each = each.value.authorizedNetworks != null ? each.value.authorizedNetworks : []
        content {
          value = authorized_networks.value
        }
      }
    }

    dynamic "database_flags" {
      for_each = each.value.flags
      content {
        name                = database_flags.key
        value               = database_flags.value
      }
    }

    maintenance_window {
      day          = each.value.maintenanceDay
      hour         = each.value.maintenanceHour
      update_track = "stable"
    }

    backup_configuration {
      enabled    = "true"
      start_time = each.value.backupStartTime
      point_in_time_recovery_enabled = each.value.pointInTimeRecoveryEnabled
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}
