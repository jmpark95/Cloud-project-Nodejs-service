resource "google_secret_manager_secret" "github_token_secret" {
  project   = var.project
  secret_id = "github"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "github_token_secret_version" {
  secret      = google_secret_manager_secret.github_token_secret.id
  secret_data = var.github_access_token
}

data "google_iam_policy" "serviceagent_secretAccessor" {
  binding {
    role    = "roles/secretmanager.secretAccessor"
    members = ["serviceAccount:service-426952566556@gcp-sa-cloudbuild.iam.gserviceaccount.com"]
  }
}

resource "google_secret_manager_secret_iam_policy" "policy" {
  project     = google_secret_manager_secret.github_token_secret.project
  secret_id   = google_secret_manager_secret.github_token_secret.secret_id
  policy_data = data.google_iam_policy.serviceagent_secretAccessor.policy_data
}

resource "google_cloudbuildv2_connection" "github_connection" {
  location = var.region
  name     = "github_connection"

  github_config {
    app_installation_id = 42090683
    authorizer_credential {
      oauth_token_secret_version = google_secret_manager_secret_version.github_token_secret_version.id
    }
  }
}

resource "google_cloudbuildv2_repository" "node_repository" {
  name              = "nodejs-service-repo"
  parent_connection = google_cloudbuildv2_connection.github_connection.id
  remote_uri        = "https://github.com/jmpark95/Cloud-project-Nodejs-service.git"
}

resource "google_cloudbuild_trigger" "repo-trigger" {
  location = var.region

  repository_event_config {
    repository = google_cloudbuildv2_repository.node_repository.id
    push {
      branch = "^main$"
    }
  }

  filename = "cloudbuild.yaml"
}