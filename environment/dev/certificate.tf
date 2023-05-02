# Get Route 53 Zone id from the remote state

data "terraform_remote_state" "hostedzone" {
  backend = "s3"
  config = {
    bucket = "skills-ontario-final-dev-state"
    key    = "hostedzone/terraform.tfstate"
    region = local.region
  }
}
# Request certificate from AWS ACM

resource "aws_acm_certificate" "this" {
  domain_name               = var.domain_name
  validation_method         = "DNS"
  subject_alternative_names = ["*.${var.domain_name}"]

  tags = {
    Name        = "${local.prefix}-cert"
    Environment = var.stage
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Add Route 53 records to allow domain validation_method

resource "aws_route53_record" "this" {
  for_each = {
  for rec in aws_acm_certificate.this.domain_validation_options : rec.domain_name => {
    name   = rec.resource_record_name
    record = rec.resource_record_value
    type   = rec.resource_record_type
  }
  }

  zone_id = data.terraform_remote_state.hostedzone.outputs.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [
    each.value.record,
  ]

  allow_overwrite = true
}

# Validate the certificate

resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for record in aws_route53_record.this : record.fqdn]
}
resource "aws_route53_record" "example" {
  name = "www"
  type = "A"
  alias {
    name                   = aws_lb.this.dns_name
    zone_id                = aws_lb.this.zone_id
    evaluate_target_health = true
  }
  zone_id = data.terraform_remote_state.hostedzone.outputs.zone_id
}
