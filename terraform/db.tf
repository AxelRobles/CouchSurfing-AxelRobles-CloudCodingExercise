resource "google_compute_global_address" "private_ip_range" {
  name          = "sql-private-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.couchsurfing_vpc.id
}

resource "google_service_networking_connection" "private_vpc_conn" {
  network                 = google_compute_network.couchsurfing_vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_range.name]
}

# Create a Cloud SQL instance
resource "google_sql_database_instance" "app_db" {
  name             = "app-db"
  database_version = "MYSQL_8_0"
  region           = var.region

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      private_network = google_compute_network.couchsurfing_vpc.id
    }
  }
}

resource "google_sql_user" "app_user" {
  name     = "appuser"
  instance = google_sql_database_instance.app_db.name
  password = var.db_password
}

resource "google_sql_database" "app_database" {
  name     = "appdb"
  instance = google_sql_database_instance.app_db.name
}