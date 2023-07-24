resource "aws_nat_gateway" "main_nat_gw" {
  allocation_id = var.elastic_IP_id
  subnet_id     = var.subnet_id

  tags = var.tags
}
# NAT Gateway requires a elastic IP
