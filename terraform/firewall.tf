# this file is used to open ssh port to access the instances
resource "google_compute_firewall" "allow-ssh" {
    name = "allow-ssh"
    network = google_compute_network.main.name

    allow {
        protocol = "tcp"
        ports    = ["22"]
    }



    source_ranges = ["0.0.0.0/0"]
  
}

resource "google_compute_firewall" "allow-api-server-to-keda-webhook" {
    name = "allow-api-server-to-keda-webhook"
    description = "Allow kubernetes api server to keda webhook call on worker nodes TCP port 9443"
    network = google_compute_network.main.name
    direction = "INGRESS"
    priority = 1000

    allow {
        protocol = "tcp"
        ports    = ["9443"]
    }

    source_ranges = ["172.16.0.0/28"]
    target_tags = ["gke-primary"]
}