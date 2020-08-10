data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  availability_zones = {
    names : data.aws_availability_zones.available.names
    count : length(data.aws_availability_zones.available.names)
  }
}