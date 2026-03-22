provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      created_by = "terraform"
    }
  }
}

#Add tf state in s3
terraform {
  backend "s3" {
    bucket         = "vp-ecs-tf-state-bucket"
    key            = "vp-ecs-tf-setup/terraform.tfstate"
    region         = "eu-west-3"
    encrypt        = true
  }
}
