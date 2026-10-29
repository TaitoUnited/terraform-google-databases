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

variable "postgresql_clusters" {
  type = list(object({
    name                       = string
    region                     = string
    cmekLocation               = optional(string)
    zone                       = string
    version                    = string
    tier                       = string
    edition                    = optional(string, "ENTERPRISE")
    maintenanceDay             = optional(number, 2)
    maintenanceHour            = optional(number, 2)
    backupStartTime            = optional(string, "22:00")
    pointInTimeRecoveryEnabled = optional(bool, true)
    highAvailabilityEnabled    = optional(bool, false)
    publicIpEnabled            = optional(bool, false)
    authorizedNetworks         = optional(list(string), [])
    flags                      = optional(map(string), {})
    defaultFlagsEnabled        = optional(bool, true)
    # adminUsername = optional(string)
  }))
  default     = []
  description = "Resources as JSON (see README.md). You can read values from a YAML file with yamldecode()."
}

variable "mysql_clusters" {
  type = list(object({
    name                       = string
    region                     = string
    cmekLocation               = optional(string)
    zone                       = string
    version                    = string
    tier                       = string
    edition                    = optional(string, "ENTERPRISE")
    maintenanceDay             = optional(number, 2)
    maintenanceHour            = optional(number, 2)
    backupStartTime            = optional(string, "22:00")
    pointInTimeRecoveryEnabled = optional(bool, true)
    highAvailabilityEnabled    = optional(bool, false)
    publicIpEnabled            = optional(bool, false)
    authorizedNetworks         = optional(list(string), [])
    # flags = optional(map(string), {})
    # defaultFlagsEnabled = optional(bool, true)
    adminUsername = optional(string)
  }))
  default     = []
  description = "Resources as JSON (see README.md). You can read values from a YAML file with yamldecode()."
}

variable "private_network_id" {
  type        = string
  default     = ""
  description = "Private network id for databases"
}
