# Specify the provider (GCP, AWS, Azure)
provider "google" {
credentials = "${file("credentials.json")}"
project = "tidy-tine-375819"
region = "us-west4"
}
