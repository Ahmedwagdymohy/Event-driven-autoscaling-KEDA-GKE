resource "google_compute_router_nat" "nat" {
  name   = "nat"
  router = google_compute_router.nat-router.name
  region = "us-east1"


  # Which private subnets will use this NAT for internet access?  
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  # Apply NAT to this specific subnet
  subnetwork {
    name = google.cloud_subnetwork.private.name
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]

  }


  nat_ips = [google_compute_address.nat-ip.self_link]

}



resource "google_compute_address" "nat-ip" {
    name = "nat-ip"
    address_type = "EXTERNAL"
    network_tier = "STANDARD"
  depends_on = [ google_project_service.compute ]
}