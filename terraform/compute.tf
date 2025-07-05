resource "google_compute_instance" "web" {
  name         = "web-app-instance-v2"
  machine_type = "e2-micro"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = 30
      type  = "pd-standard"
    }
  }

  network_interface {
    network    = google_compute_network.couchsurfing_vpc.id
    subnetwork = google_compute_subnetwork.web_subnet.id

    access_config {}
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    # Install necessary packages
    apt-get update
    apt-get install -y git docker.io
    systemctl start docker
    systemctl enable docker

    git clone https://github.com/AxelRobles/CouchSurfing-AxelRobles-CloudCodingExercise.git /opt/app

    docker build -t fastapi-app /opt/app/app

    # Run the Docker container
    docker run -d -p 80:5000 -e DB_HOST='${google_sql_database_instance.app_db.private_ip_address}' -e DB_USER='${google_sql_user.app_user.name}' -e DB_PASSWORD='${var.db_password}' -e DB_NAME='${google_sql_database.app_database.name}' --name fastapi-container fastapi-app
  EOT

  tags = ["web-app", "ssh-tag"]
}