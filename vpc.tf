resource "aws_vpc" "rusk_app" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true

    tags = {
        Name = "rusk_app"
    }
}

resource "aws_internet_gateway" "rusk_app" {
    vpc_id = "${aws_vpc.rusk_app.id}"

    tags = {
        Name = "rusk_app_main"
    }
}

/*
  Public Subnet
*/
resource "aws_subnet" "rusk_app_public" {
    vpc_id = "${aws_vpc.rusk_app.id}"

    cidr_block = "${var.public_subnet_cidr}"
    availability_zone = "${var.aws_region}a"

    tags = {
        Name = "rusk_app-${var.aws_region}a-public"
    }
}

resource "aws_route_table" "rusk_app_public" {
    vpc_id = "${aws_vpc.rusk_app.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.rusk_app.id}"
    }

    tags = {
        Name = "rusk_app-${var.aws_region}a-public"
    }
}

resource "aws_route_table_association" "rusk_app_public" {
    subnet_id = "${aws_subnet.rusk_app_public.id}"
    route_table_id = "${aws_route_table.rusk_app_public.id}"
}