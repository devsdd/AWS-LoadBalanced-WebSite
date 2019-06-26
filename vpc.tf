resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_ip_range}"

  tags = {
    Name = "${var.client}-VPC",
  }
}

resource "aws_subnet" "pub1" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.pubnet1}"
  availability_zone = "${var.region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.client}-PublicSubnetA",
  }
}

resource "aws_subnet" "pub2" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.pubnet2}"
  availability_zone = "${var.region}b"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.client}-PublicSubnetB",
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "${var.client}-IGW",
  }
}

resource "aws_route_table" "internet" {
  vpc_id = "${aws_vpc.main.id}"
  # propagating_vgws = ["${aws_vpn_gateway.vgw.id}"]

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags = {
    Name = "${var.client}Internet",
  }
}

resource "aws_route_table_association" "assoc-pubnet1" {
  subnet_id = "${aws_subnet.pub1.id}"
  route_table_id = "${aws_route_table.internet.id}"
}

resource "aws_route_table_association" "assoc-pubnet2" {
  subnet_id = "${aws_subnet.pub2.id}"
  route_table_id = "${aws_route_table.internet.id}"
}
