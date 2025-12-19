terraform {
  backend "s3" {
    bucket  = "tfstate-fiap-alex-academy-rds-new"
    key     = "tfstate"
    region  = "us-east-1"
    encrypt = false
  }
}
