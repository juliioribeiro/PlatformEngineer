terraform {
  backend "s3" {
    bucket = "engineer-remote-state"
    key    = "eks"
    region = "us-east-2"
  }
}
