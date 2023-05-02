output "name_servers" {
  description = "Name servers for the public hosted zone. Update Freenom settings"
  value       = aws_route53_zone.this.name_servers
}
output "zone_id" {
  description = "Zone id to be used in domain validation process"
  value       = aws_route53_zone.this.zone_id
}