output "id" {
  description = "VPC id"
  value       = var.enabled ? aws_vpc.this.0.id : ""
}

output "vpc_cidr_block" {
  description = "VPC CIDR Block"
  value       = var.enabled ? aws_vpc.this.0.cidr_block : ""
}

output "subnet_public_ids" {
  description = "List of private subnet id"
  value       = var.enabled ? aws_subnet.public.*.id : []
}

output "subnet_private_ids" {
  description = "List of private subnet id"
  value       = var.enabled ? aws_subnet.private.*.id : []
}

output "availability_zones_count" {
  description = "Number of availability zones used"
  value       = var.enabled ? max(local.availability_zones.count, var.max_availability_zones) : 0
}