## 3 security groups

#ALB security group
resource "aws_security_group" "alb_sg" {
  name        = "${var.prefix}-alb-sg"
  description = "Security group for ALB"
  vpc_id      = aws_vpc.tf-ecs-vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# ECS tasks security group
resource "aws_security_group" "ecs_tasks_sg" {
  name        = "${var.prefix}-ecs-tasks-sg"
  description = "Security group for ECS tasks"
  vpc_id      = aws_vpc.tf-ecs-vpc.id
  depends_on = [ aws_security_group.alb_sg ]
}

resource "aws_vpc_security_group_ingress_rule" "allow_for_app" {
  security_group_id = aws_security_group.ecs_tasks_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = var.container_port
  ip_protocol       = "tcp"
  to_port           = var.container_port
  #referenced_security_group_id = aws_security_group.alb_sg.id # only allow traffic from ALB security group
}

resource "aws_vpc_security_group_egress_rule" "allow_all_ecs-app" {
  security_group_id = aws_security_group.ecs_tasks_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# RDS security group
resource "aws_security_group" "db_sg" {
  name        = "${var.prefix}-db-sg"
  description = "Security group for RDS instance"
  vpc_id      = aws_vpc.tf-ecs-vpc.id
  depends_on = [ aws_security_group.ecs_tasks_sg ]
}

resource "aws_vpc_security_group_ingress_rule" "allow_for_ingress_db" {
  security_group_id = aws_security_group.db_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 5432
  ip_protocol       = "tcp"
  to_port           = 5432
  #referenced_security_group_id = aws_security_group.ecs_tasks_sg.id # only allow traffic from ECS tasks security group
}

resource "aws_vpc_security_group_egress_rule" "allow_all_egress_db" {
  security_group_id = aws_security_group.db_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}