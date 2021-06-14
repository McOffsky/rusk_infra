resource "local_file" "rusk_ansible_key" {
  content         = tls_private_key.rusk_ansible.private_key_pem
  filename        = "./.ssh/rusk_ansible.pem"
  file_permission = "0600"
}

resource "local_file" "inventory" {
 content = templatefile("ansible/inventory.tmpl",
    {
    jenkins-dns = aws_instance.rusk_jenkins1.public_dns,
    jenkins-ip = aws_instance.rusk_jenkins1.public_ip,
    jenkins-id = aws_instance.rusk_jenkins1.id

    web-dns = aws_instance.rusk_web1.public_dns,
    web-ip = aws_instance.rusk_web1.public_ip,
    web-id = aws_instance.rusk_web1.id
    }
 )
 filename = ".ansible/inventory"
}

