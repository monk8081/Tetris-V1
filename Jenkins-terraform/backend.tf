terraform {
  backend "s3" {
    bucket = "monkbucket80" # Replace with your actual S3 bucket name 
    key    = "Jenkins/terraform.tfstate"
    region = "ap-south-1"
  }
}
