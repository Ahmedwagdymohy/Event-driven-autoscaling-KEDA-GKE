# here we will create a router with NAT to allow outbound internet access for private instances
resource "google_compute_router" "nat-router" {
  name    = "nat-router"
  network = google_compute_network.main.id
  region  = "us-east1"
}
