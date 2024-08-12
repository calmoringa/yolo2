provider "aws" {
  region = "eu-north-1"
}

resource "aws_instance" "web" {
  ami           = "ami-04ac98afcd13fac1f"
  instance_type = "t3.nano"
  key_name      = "ec2deploy" # Updated to use your key pair

  # Network and Security
  vpc_security_group_ids = ["sg-0c9d0d92cd590555d"]
  subnet_id              = "subnet-05fad511a00c8dd42"

  tags = {
    Name = "Yolo"
  }

  # Use remote-exec to install Docker and Docker Compose
  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y docker",
      "sudo service docker start",
      "sudo usermod -aG docker ec2-user",
      "curl -L \"https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)\" -o /usr/local/bin/docker-compose",
      "sudo chmod +x /usr/local/bin/docker-compose"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("${path.module}/ec2deploy.pem")
      host        = self.public_ip
      timeout     = "2m"
    }
  }

  # Use local-exec to run Ansible playbook
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i '${self.public_ip},' --private-key ${path.module}/ec2deploy.pem ansible/playbook.yml"
  }
}

output "instance_ip" {
  description = "The public IP address of the web server"
  value       = aws_instance.web.public_ip
}
