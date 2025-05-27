resource "aws_instance" "wazuh-dev" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  iam_instance_profile   = var.iam_instance_profile

  user_data = templatefile("${path.module}/../../scripts/install_wazuh.sh", {
    docker_compose = file("${path.module}/../../docker/docker-compose.yml")
  })

  tags = {
    Name = "wazuh-ec2"
  }
}