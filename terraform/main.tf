resource "google_project_service" "servicenetworking" {
  service = "servicenetworking.googleapis.com"
  depends_on = [google_project_service.compute]
}

resource "google_project_service" "sqladmin" {
  service = "sqladmin.googleapis.com"
  depends_on = [google_project_service.servicenetworking]
}

resource "google_project_service" "compute" {
  project = var.project_id
  service = "compute.googleapis.com"
}
