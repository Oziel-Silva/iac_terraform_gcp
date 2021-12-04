provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

resource "google_compute_instance" "master-01" {
  name         = "master-01"
  machine_type = "e2-medium"
  tags         = ["master"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network = "default"
    access_config {
    }
  }
}

resource "google_compute_instance" "worker" {
  name         = "worker-${count.index + 1}"
  machine_type = "e2-medium"
  count        = 2
  tags         = ["node"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network = "default"
    access_config {
    }
  }
}
data "google_client_openid_userinfo" "me" {
}
resource "google_os_login_ssh_public_key" "my_key_pub" {
  user =  data.google_client_openid_userinfo.me.email
  key = file("~/.ssh/google_compute_engine.pub")
}