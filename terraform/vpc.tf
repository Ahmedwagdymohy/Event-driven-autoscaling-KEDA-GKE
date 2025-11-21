# we should enable the compute and container APIs for GKE clusters
resource "google_project_service" "compute" {
  service = "compute.googleapis.com"
}


resource "google_project_service" "container" {
  service = "container.googleapis.com"
}


resource "google_compute_network" "main" {
  name                    = "main-vpc-network"
  auto_create_subnetworks = false
  routing_mode = "REGIONAL"
  mtu = 1460
  delete_default_routes_on_create = false

    # this tells terraform to wait until the APIs are enabled
    depends_on = [
        google_project_service.compute,
        google_project_service.container,
    ]

}