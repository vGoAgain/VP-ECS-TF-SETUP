variable "aws_region" {
  type        = string
  description = "the aws region in which the infra will be setup"
  default     = "eu-west-3"
}

variable "vpc_name" {
  default     = "jan2026-tf-vpc"
  type        = string
  description = "the vpc created with tf"
}

variable "primary-az" {
  default     = "eu-west-3a"
  type        = string
  description = "the primary availability zone"
}

variable "secondary-az" {
  default     = "eu-west-3b"
  type        = string
  description = "the secondary availability zone"
}

variable "app_name" {
  default = "student-portal"
}

variable "prefix" {
  default = "vp"
}