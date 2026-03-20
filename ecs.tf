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
          protocol      = "tcp"
        }
      ]
      environment = [{
      name  = "AWS_REGION"
      value = "eu-west-3"
      }, {
      name  = "DB_SECRET_NAME"
      value = "prod/awslens/db"
      }, {
      name  = "FLASK_SECRET_KEY"
      value = "some-random-text"
      }]
      logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-create-group  = "true"
        awslogs-group         = "/ecs/ecs-vp-aws-lens"
        awslogs-region        = "eu-west-3"
        awslogs-stream-prefix = "ecs"
      }
      secretOptions = []
      }
    }
  ])
  execution_role_arn = ""
  requires_compatibilities = ["FARGATE"]
}

# ECS service