locals {
  public_count = var.enabled ? max(local.availability_zones.count, var.max_availability_zones) : 0
}

resource "aws_subnet" "public" {
  count = local.public_count

  vpc_id                  = aws_vpc.this.0.id
  availability_zone       = local.availability_zones.names[count.index]
  map_public_ip_on_launch = var.map_public_ip_on_launch

  cidr_block = cidrsubnet(
    aws_vpc.this.0.cidr_block,
    ceil(log(local.public_count * 2, 2)),
    local.public_count + count.index
  )

  tags = merge(
    {
      "Name" = format(var.label_formatter, format("public-%s", local.availability_zones.names[count.index]))
    },
    var.tags,
    var.subnet_tags
  )
}

resource "aws_route_table" "public" {
  count = local.public_count

  vpc_id = aws_vpc.this.0.id

  tags = merge(
    {
      "Name" = format(var.label_formatter, format("public-%s", local.availability_zones.names[count.index]))
    },
    var.tags
  )
}

resource "aws_route_table_association" "public" {
  count = local.public_count

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[count.index].id
}

resource "aws_route" "internet" {
  count = local.public_count

  route_table_id         = aws_route_table.public[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.0.id
}
