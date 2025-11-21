resource "google_container_cluster" "primary" {
    name = "primary"
    location = "us-east1"
    remove_default_node_pool = true
    initial_node_count = 1
    network = google_compute_network.main.name
    subnetwork = google_compute_subnetwork.private.self_link
    networking_mode = "VPC_NATIVE"



    node_config {
    disk_size_gb = 30
    disk_type    = "pd-standard"
    }
  
    addons_config {
        # Disable it as we will use ingress-nginx controller instead
        http_load_balancing {
            disabled = true
    }
    horizontal_pod_autoscaling {
        disabled = false
    }

}


    # this means : Please automatically upgrade my GKE control plane to new Kubernetes versions on a normal, predictable schedule – not too early, not too late.
    release_channel {
        channel = "REGULAR"
    }


    workload_identity_config {
        workload_pool = "supple-alpha-474315-q5.svc.id.goog"
  }

    ip_allocation_policy {
      cluster_secondary_range_name = "k8s-pod-range"
      services_secondary_range_name = "k8s-service-range"
    }

    private_cluster_config {
      enable_private_nodes    = true
      enable_private_endpoint = false
      master_ipv4_cidr_block  = "172.16.0.0/28"
  }
}