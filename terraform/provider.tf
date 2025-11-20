
provider "google" {
  project     = "supple-alpha-474315-q5"
  region      = "us-east1"
}



# defining the backend file to store the terraform state
terraform {
  backend "gcs" {
    bucket = "tf-state-keda"
    prefix = "terraform/state"
    
  }
}