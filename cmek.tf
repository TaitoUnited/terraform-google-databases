/**
 * Copyright 2026 Taito United
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

resource "google_project_service_identity" "gcp_sa_cloud_sql" {
  provider = google-beta
  service  = "sqladmin.googleapis.com"
}

resource "google_kms_key_ring" "cmek" {
  for_each = {for location in local.cmekLocations: location => location}

  provider = google-beta
  name     = "database-cmek-${each.key}"
  location = each.key
}

resource "google_kms_crypto_key" "cmek_key" {
  for_each = {for location in local.cmekLocations: location => location}

  provider = google-beta
  name     = "database-cmek-${each.key}-key"
  key_ring = google_kms_key_ring.cmek[each.key].id
  purpose  = "ENCRYPT_DECRYPT"

  rotation_period = "7776000s" # 90 days

  lifecycle {
    prevent_destroy = true
  }  
}

resource "google_kms_crypto_key_iam_binding" "crypto_key" {
  for_each = {for location in local.cmekLocations: location => location}

  provider      = google-beta
  crypto_key_id = google_kms_crypto_key.cmek_key[each.key].id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

  members = [
    "serviceAccount:${google_project_service_identity.gcp_sa_cloud_sql.email}",
  ]
}
