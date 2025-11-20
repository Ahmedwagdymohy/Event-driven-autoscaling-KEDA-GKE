resource "google_compute_subnetwork" "private" {
  name         = "private-subnet"
  ip_cidr_range = "10.0.0.0/18"
  network     = google_compute_network.main.id
  private_ip_google_access = true
  region      = "us-east1"

    #This technique of creating two ip ranges is for Networking mode called "VPC_NATIVE" in GKE
    # We specify two ip ranges for pods and services and when creating the cluster we mention networking_mode = "VPC_NATIVE"
    secondary_ip_range {
        range_name    = "k8s-pod-range"
        ip_cidr_range = "10.48.0.0/14"
}
    secondary_ip_range {
        range_name    = "k8s-service-range"
        ip_cidr_range = "10.52.0.0/20"
}
}