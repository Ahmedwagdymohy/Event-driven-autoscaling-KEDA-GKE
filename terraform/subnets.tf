resource "google_cloud_subnetwork" "private" {
  name         = "private-subnet"
  ip_cidr_range = "10.0.0.0/18"
  network     = google_compute_network.main.id
  private_ip_google_access = true
  region      = "us-east1"

    secondary_ip_range {
        range_name    = "k8s-pod-range"
        ip_cidr_range = "10.48.0.0/14"
}
    secondary_ip_range {
        range_name    = "k8s-service-range"
        ip_cidr_range = "10.52.0.0/20"
}
}