terraform {
  backend "s3" {
    bucket = "skills-ontario-final-dev-state"
    key    = "hostedzone/terraform.tfstate"
    region = "us-east-1"
  }
}
