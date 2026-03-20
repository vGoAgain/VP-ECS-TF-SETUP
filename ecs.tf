#ECR repo to store image
resource "aws_ecr_repository" "tf-ecr-repo" {
  name                 = "${var.prefix}-${var.app_name}"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}

### ECS compennets


# ECS cluster
resource "aws_ecs_cluster" "tf-ecs-cluster" {
  name = "${var.prefix}-${var.app_name}-cluster"

    /*
  setting {
    name  = "containerInsights"
    value = "enabled"
  }*/
}

# task definition
resource "aws_ecs_task_definition" "service" {
  family = var.app_name
  network_mode = "awsvpc"
  container_definitions = jsonencode([
    {
      name      = var.app_name
      image     = var.image
      cpu       = 1024
      memory    = 2048
      essential = true
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
        }
      ]
    }
  ])

}

# ECS service