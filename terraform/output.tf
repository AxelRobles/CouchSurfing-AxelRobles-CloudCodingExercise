output "web_instance_ip" {
  description = "Public IP of the web instance"
  value       = google_compute_instance.web.network_interface[0].access_config[0].nat_ip
}