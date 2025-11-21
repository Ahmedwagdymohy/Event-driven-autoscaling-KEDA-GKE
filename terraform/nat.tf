resource "google_compute_router_nat" "nat" {
  name                               = "nat"
  router                             = google_compute_router.nat-router.name
  region                             = "us-east1"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  # This is the line you are missing – now required
  nat_ip_allocate_option             = "MANUAL_ONLY"

  # Because you chose MANUAL_ONLY, you must provide the IPs yourself
  nat_ips = [google_compute_address.nat-ip.self_link]

  subnetwork {
    name                    = google_compute_subnetwork.private.name
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}

resource "google_compute_address" "nat-ip" {
  name         = "nat-ip"
  address_type = "EXTERNAL"
  network_tier = "STANDARD"
  region       = "us-east1"        # add region (good practice)
  depends_on   = [google_project_service.compute]
}