resource "google_compute_network" "couchsurfing_vpc" {
  name                    = "couchsurfing-prod"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "web_subnet" {
  name          = "web-app-subnet"
  ip_cidr_range = "10.0.0.0/24"
  region        = var.region
  network       = google_compute_network.couchsurfing_vpc.id
}

resource "google_compute_route" "default_internet_route" {
  name             = "default-internet-route"
  network          = google_compute_network.couchsurfing_vpc.id
  dest_range       = "0.0.0.0/0"
  next_hop_gateway = "default-internet-gateway"
  priority         = 1000
}

resource "google_compute_firewall" "allow_couchsurfing_http" {
  name    = "allow-couchsurfing-http"
  network = google_compute_network.couchsurfing_vpc.id

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["web-app"]
}

resource "google_compute_firewall" "allow_https" {
  name    = "allow-https"
  network = google_compute_network.couchsurfing_vpc.id

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["web-app"]
}

resource "google_compute_firewall" "allow_iap_ssh" {
  name    = "allow-iap-ssh"
  network = google_compute_network.couchsurfing_vpc.id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  # This is the specific IP range for Google's IAP service.
  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["ssh-tag"]
}