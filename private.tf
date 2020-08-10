locals {
  private_count = var.enabled ? max(local.availability_zones.count, var.max_availability_zones) : 0
}

resource "aws_subnet" "private" {
  count = local.private_count

  vpc_id            = aws_vpc.this.0.id
  availability_zone = local.availability_zones.names[count.index]

  cidr_block = cidrsubnet(
    aws_vpc.this.0.cidr_block,
    ceil(log(local.private_count * 2, 2)),
    count.index
  )

  tags = merge(
    {
      "Name" = format(var.label_formatter, format("private-%s", local.availability_zones.names[count.index]))
    },
    var.tags,
    var.subnet_tags
  )
}

resource "aws_route_table" "private" {
  count = local.private_count

  vpc_id = aws_vpc.this.0.id

  tags = merge(
    {
      "Name" = format(var.label_formatter, format("private-%s", local.availability_zones.names[count.index]))
    },
    var.tags
  )
}

resource "aws_route_table_association" "private" {
  count = local.private_count

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

resource "aws_route" "nat" {
  count = var.nat_gateway_enabled ? local.private_count : 0

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.this.*.id, var.nat_gateway_ha ? count.index : 0)

  timeouts {
    create = "15m"
    delete = "15m"
  }
}

