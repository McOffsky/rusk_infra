resource "aws_instance" "rusk_jenkins1" {
  ami = "${lookup(var.ubuntu_ami, var.aws_region)}"
  instance_type = "t2.medium"
  key_name = "${aws_key_pair.rusk_ansible.key_name}"
  vpc_security_group_ids = ["${aws_security_group.rusk_jenkins.id}"]
  subnet_id = "${aws_subnet.rusk_app_public.id}"
  associate_public_ip_address = true
  source_dest_check = false
  
  tags = {
      Name = "rusk_jenkins1"
  }

  connection {
      type = "ssh"
      user = "ubuntu"
      host = "${self.public_dns}"
      private_key = "${tls_private_key.rusk_ansible.private_key_pem}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /srv/keys/jenkins",
      "sudo chown -R ubuntu:ubuntu /srv/keys"
    ]
  }

  provisioner "file" {
    content     = "${tls_private_key.rusk_jenkins1.private_key_pem}"
    destination = "/srv/keys/jenkins/id_rsa"
  }

  root_block_device {
    volume_size = "64"
  }
}



resource "aws_instance" "rusk_web1" {
  ami = "${lookup(var.ubuntu_ami, var.aws_region)}"
  instance_type = "t2.medium"
  key_name = "${aws_key_pair.rusk_ansible.key_name}"

  vpc_security_group_ids = ["${aws_security_group.rusk_web.id}"]
  subnet_id = "${aws_subnet.rusk_app_public.id}"
  associate_public_ip_address = true
  source_dest_check = false

  tags = {
      Name = "rusk_web1"
      Type = "rusk_app_webworker"
  }

  connection {
      type = "ssh"
      user = "ubuntu"
      host = "${self.public_dns}"
      private_key = "${tls_private_key.rusk_ansible.private_key_pem}"
  }

  provisioner "remote-exec" {
    inline = [
      "echo '${aws_key_pair.rusk_jenkins1.public_key}' >> ~/.ssh/authorized_keys"
    ]
  }
}