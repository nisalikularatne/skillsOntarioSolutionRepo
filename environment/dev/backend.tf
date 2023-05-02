terraform {
  backend "s3" {
    bucket = "skills-ontario-final-dev-state"
    key    = "core-infrastructure/terraform.tfstate"
    region = "us-east-1"
  }

}
