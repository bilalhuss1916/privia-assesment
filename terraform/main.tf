resource "google_compute_instance" "default" {
  for_each     = {
  "vm1" = "web-server1"
  "vm2" = "web-server2"
  }

  name         = each.value
  machine_type = "e2-medium"
  zone         = "us-west4-b"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Include this section to give the VM an external ip address
    }
  }

    #metadata_startup_script = "sudo apt-get update && sudo apt-get install apache2 -y && echo '<!doctype html><html><body><h1>Hello World!</h1></body></html>' | sudo tee /var/www/html/index.html"

    // Apply the firewall rule to allow external IPs to access this instance
    tags = ["http-server"]
}

resource "google_compute_firewall" "http-server" {
  name    = "default-allow-http-terraform"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  // Allow traffic from everywhere to instances with an http-server tag
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}

#output "ip" {
#  value = "${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}"
#}
