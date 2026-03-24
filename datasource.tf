# we are going to use data source  to fetch the public hosted zone id for our domain name.
# Since we already have this resource crated and usualy something like the domain is created only once.

#public hosted zone -> data source

data "aws_route53_zone" "existing-vp-domain" {
  name         = "vaishakhprasad.com"
  private_zone = false
}

output "public_hosted_Zone" {
  value = data.aws_route53_zone.existing-vp-domain.name
}


# dns reoute53 -> ALB 
resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.existing-vp-domain.zone_id
  name    = "${var.app_name}.${data.aws_route53_zone.existing-vp-domain.name}"
  type    = "A"

  alias {
    name                   = aws_lb.tf-ecs-awslens-alb.dns_name
    zone_id                = aws_lb.tf-ecs-awslens-alb.zone_id
    evaluate_target_health = true
  }
}

# Add ACM to the ALB listener
 
resource "aws_acm_certificate" "cert" {
  domain_name       = "${var.app_name}.${data.aws_route53_zone.existing-vp-domain.name}"
  validation_method = "DNS"

  validation_option {
    domain_name       = "${var.app_name}.${data.aws_route53_zone.existing-vp-domain.name}"
    validation_domain = "${data.aws_route53_zone.existing-vp-domain.name}"
  }
}

#Certificate validation record
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.existing-vp-domain.zone_id
}