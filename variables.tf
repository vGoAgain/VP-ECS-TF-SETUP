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
  default = "aws-lens"
}

variable "prefix" {
  default = "vp"
}

variable "image" {
  type = string
  default = "477059411744.dkr.ecr.eu-west-3.amazonaws.com/vp/vp-aws-lens:1.0"
}

variable "container_port" {
  default = 5000
  type = number
}