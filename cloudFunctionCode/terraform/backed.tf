
terraform {
  backend "gcs" {
    bucket = "tf-state-bucket-for-cla-code"
    prefix = "pocState"
    # credentials = "C:/gcp_poc/key/cla-poc-key.json"
    # credentials = file("./cla-poc-key.json")
  }
} 