
provider "google" {
  credentials = file("gcp_service_account.json")
  project = "task-2-gks"
  region  = "us-central1"
  zone    = "us-central1-c"
}
