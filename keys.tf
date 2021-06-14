resource "tls_private_key" "rusk_jenkins1" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "rusk_jenkins1" {
  key_name   = "rusk_jenkins1_public_key"
  public_key = tls_private_key.rusk_jenkins1.public_key_openssh
}

resource "tls_private_key" "rusk_ansible" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "rusk_ansible" {
  key_name   = "rusk_ansible_public_key"
  public_key = tls_private_key.rusk_ansible.public_key_openssh
}