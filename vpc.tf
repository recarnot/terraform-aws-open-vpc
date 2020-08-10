resource "aws_vpc" "this" {
  count = var.enabled ? 1 : 0

  cidr_block = var.cidr_block

  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  assign_generated_ipv6_cidr_block = var.assign_generated_ipv6_cidr_block

  tags = merge(
    var.tags,
    {
      Name : format(var.label_formatter, "vpc")
    }
  )
}

resource "aws_egress_only_internet_gateway" "this" {
  count = var.enabled && var.assign_generated_ipv6_cidr_block ? 1 : 0

  vpc_id = aws_vpc.this[0].id

  tags = merge(
    {
      "Name" = format(var.label_formatter, "ipv6")
    },
    var.tags
  )
}
