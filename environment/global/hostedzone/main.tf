resource "aws_route53_zone" "this" {
  name          = var.domain_name
  force_destroy = true

  tags = {
    Environment = var.stage,
    Name        = "${var.namespace}-${var.stage}-${var.name}-zone"
  }
}
