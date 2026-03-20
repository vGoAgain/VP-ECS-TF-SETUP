ECS 2-tier app infra using Terraform

-VPC
    - 2 private
    - 2 public
    - 2 RDS private subnet

    - 2 route tables
    - associate RT
    - 1 NAT gateway
    - Route for public and private

    - Security groups
        - RDS ecs and alb
        - Open port wherever needed

ALB
    - Target Group
    - ALB on public subnet
    - ACM cert for ssl
    - Listener 80
    - Listener 443
    - WAF

APP 
    -ECR
        - ECR repo
        - push app image
    -ECS
        - ECS Task def
        - ECS cluster
        - ECS services
        - App auto scaling

DNS
    - route53 zone
    - create route to alb
    - acm cert vlaidation

DB
    - rds
    - secret manager for password
    - generate randome password
    - kms key



Question ::
if you want to update the rds version from x to y then how will we update