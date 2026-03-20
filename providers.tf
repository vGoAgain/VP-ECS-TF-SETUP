provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      created_by = "terraform"
    }
  }
}

#Add tf state in s3
