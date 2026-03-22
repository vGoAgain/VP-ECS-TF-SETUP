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
resource "aws_ecs_task_definition" "tf-ecs-task-def" {
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
      value = var.aws_region
      }, {
      name  = "DB_SECRET_NAME"
      value = aws_secretsmanager_secret.db-password.arn
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
  cpu = 1024
  memory = 2048
  execution_role_arn = aws_iam_role.ecs_task_role.arn
  task_role_arn = aws_iam_role.ecs_task_role.arn
  requires_compatibilities = ["FARGATE"]

  depends_on = [ aws_iam_role.ecs_task_role ]
}

# ECS service
resource "aws_ecs_service" "tf-ecs-service" {
  name            = "${var.prefix}-${var.app_name}-service"
  cluster         = aws_ecs_cluster.tf-ecs-cluster.id
  task_definition = aws_ecs_task_definition.tf-ecs-task-def.arn
  desired_count   = 1
  #iam_role        = aws_iam_role.ecs_task_role.arn
  launch_type     = "FARGATE"
  
  network_configuration {
    assign_public_ip = false
    subnets = [ aws_subnet.tf-ecs-private-subnet-1.id, aws_subnet.tf-ecs-private-subnet-2.id ]
    security_groups = [ aws_security_group.ecs_tasks_sg.id ]
  }
}