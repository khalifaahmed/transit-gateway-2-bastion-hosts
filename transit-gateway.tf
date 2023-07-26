
resource "aws_ec2_transit_gateway" "main_tg" {
  description = "main-tg"
}

resource "aws_ec2_transit_gateway_vpc_attachment" "my_vpc_tg_attachment" {
  subnet_ids         = ["${aws_subnet.private[0].id}"]
  transit_gateway_id = "${aws_ec2_transit_gateway.main_tg.id}"
  vpc_id             = "${aws_vpc.my_vpc.id}"
}

resource "aws_ec2_transit_gateway_vpc_attachment" "main_tg_attachment" {
  subnet_ids         = ["${aws_subnet.main_private[0].id}"]
  transit_gateway_id = "${aws_ec2_transit_gateway.main_tg.id}"
  vpc_id             = "${aws_vpc.main.id}"
}

resource "aws_route" "my_vpc_tg_route" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "10.10.0.0/16"
  transit_gateway_id             = aws_ec2_transit_gateway.main_tg.id
}

resource "aws_route" "main_tg_route" {
  route_table_id         = aws_route_table.main_private.id
  destination_cidr_block = "10.0.0.0/16"
  transit_gateway_id              = aws_ec2_transit_gateway.main_tg.id
}

