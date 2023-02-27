
resource "google_service_account" "service_account_gks" {
  account_id   = "gks-service-account"
  display_name = "Dummy Service Account"
}

resource "google_project_iam_binding" "firestore_owner_binding" {
  role    = "roles/datastore.owner"
  project = "task-2-gks"
  members = [
    "serviceAccount:gks-service-account@task-2-gks.iam.gserviceaccount.com",
  ]
  depends_on = [google_service_account.service_account_gks]
}

# GKE cluster
resource "google_container_cluster" "primary" {
  name                     = "mediawiki-cluster-gke"
  location                 = "us-central1"
  remove_default_node_pool = true
  initial_node_count       = 1

}

resource "google_container_node_pool" "primary_nodes" {
  name       = google_container_cluster.primary.name
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = var.gke_num_nodes

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      env = var.project_id
    }

    # preemptible  = true
    machine_type = "n1-standard-1"
    tags         = ["gke-node", "mediawiki-cluster-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}

resource "null_resource" "helm_install" {
  provisioner "local-exec" {
    command = "/bin/bash helmdeploy.sh"
  }

}
resource "null_resource" "on_destroy" {
  provisioner "local-exec" {
    when    = destroy
    command = "helm delete mediawiki-chart"
  }
}
