terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.42.0"
    }
  }
}

provider "google" {
  credentials = file("sa-key.json")
  project     = var.project
  region      = var.region
  zone        = var.zone
}

resource "google_compute_instance" "master" {
  count                   = var.master_count
  name                    = "${var.lab_name}-${var.Application_Name}-server-trainee-${count.index + 1}"
  machine_type            = local.master_instance_type
  metadata_startup_script = file("${var.Application_Name}.sh")

  /*
  scheduling {
    provisioning_model = "SPOT"
    preemptible        = true
    automatic_restart  = false
  }
*/
  tags = ["${var.lab_name}-${var.Application_Name}"]
  labels = {
    name                                      = "${var.lab_name}-${var.Application_Name}-server-trainee-${count.index + 1}"
    application_name                          = var.Application_Name
    "${var.lab_name}-${var.Application_Name}" = "gitlab-server-${count.index + 1}"
    //    email                                     = "${var.email}"   // Yet to validate
    epoch_id = "${var.epoch_id}"
  }

  boot_disk {
    auto_delete = true
    mode        = "READ_WRITE"
    initialize_params {
      image = data.google_compute_image.master_ami_image.self_link # Type 01
      size  = var.master_instance_storage
      type  = "pd-standard"
      labels = {
        name = "${var.lab_name}-${var.Application_Name}-server-trainee-${count.index + 1}"
      }
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }
}

resource "google_compute_firewall" "default-master-security-group" {
  name    = "${var.lab_name}-${var.Application_Name}-default-master-security-group"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["${var.lab_name}-${var.Application_Name}"]
}

resource "google_compute_firewall" "master_security_group" {
  name    = "${var.lab_name}-${var.Application_Name}-master-security-group"
  network = "default"

  allow {
    protocol = "tcp"
    // ports    = var.master_ports
    ports = ["1000-50000"]

  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["${var.lab_name}-${var.Application_Name}"]
}
