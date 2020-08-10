resource "aws_internet_gateway" "this" {
  count = var.enabled ? 1 : 0

  vpc_id = aws_vpc.this.0.id

  tags = merge(
    {
      "Name" = format(var.label_formatter, "igw")
    },
    var.tags
  )
}

locals {
  nat_count = (var.enabled && var.nat_gateway_enabled
    ? var.nat_gateway_ha ? max(local.availability_zones.count, var.max_availability_zones) : 1
    : 0
  )
}

resource "aws_eip" "nat" {
  count = local.nat_count

  vpc = true

  tags = merge(
    {
      "Name" = format(var.label_formatter, local.availability_zones.names[count.index])
    },
    var.tags
  )
}

#Creates NAT Gateway
resource "aws_nat_gateway" "this" {
  count = local.nat_count

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(
    {
      "Name" = format(var.label_formatter, local.availability_zones.names[count.index])
    },
    var.tags
  )

  depends_on = [aws_internet_gateway.this]
}

