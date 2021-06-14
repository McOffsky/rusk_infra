resource "aws_eip" "rusk_jenkins1" {
    instance = "${aws_instance.rusk_jenkins1.id}"
    vpc = true

    tags = {
        Name = "rusk_app_eip_jenkins1"
    }
}

resource "aws_eip" "rusk_web1" {
    instance = "${aws_instance.rusk_web1.id}"
    vpc = true

    tags = {
        Name = "rusk_app_eip_web1"
    }
}