#---------------------------------------------------
# Provision two docker node
# Create:
#   - instance
#   - Security Group
#   - Network Interface
#
# Made by Vladialv Eldyshev
#---------------------------------------------------

# DataSource
data "aws_subnet" "prod-subnet" {
  tags = {
    Name = "prod-subnet"
  }
}

data "aws_vpc" "production" {
  tags = {
    Name = "production"
  }
}

data "aws_availability_zones" "working_zone" {}

data "template_file" "docker_init_tpl" {
  template = file("docker_init.sh.tpl")
  vars = {
    dtrUser     = "${var.DTR["user"]}"
    dtrKey      = "${var.DTR["key"]}"
    dtrRegistry = "${var.DTR["registry"]}"
  }
}

#===================================


provider "aws" {
  access_key = var.a_key
  secret_key = var.s_key
  region     = var.reg
}

resource "aws_network_interface" "internal" {
  subnet_id   = data.aws_subnet.prod-subnet.id
  private_ips = ["${var.local_net}.100"]

  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_instance" "node00" {
  ami           = var.ec2["ami"]
  instance_type = var.ec2["type"]
  #vps_security_group_ids = ["sg-042b7328321b4f994"]
  key_name                    = var.ssh_key_name
  vpc_security_group_ids      = [aws_security_group.production-internal.id]
  subnet_id                   = data.aws_subnet.prod-subnet.id
  associate_public_ip_address = true
  #private_ips = ["${var.local_net}.1"]

  # network_interface {
  #   network_interface_id = aws_network_interface.internal.id
  #   device_index         = 0
  # }

  root_block_device {
    volume_size           = "8"
    volume_type           = "gp2"
    delete_on_termination = "true"
  }
  # user_data = templatefile("docker_init.sh.tpl", {
  #   dtrUser     = "${var.DTR["user"]}"
  #   dtrKey      = "${var.DTR["key"]}"
  #   dtrRegistry = "${var.DTR["registry"]}"
  #   }
  # )
  user_data = data.template_file.docker_init_tpl.rendered
  provisioner "file" {
    source      = var.key_file_path
    destination = var.key_file_path

    connection {
      host        = self.public_ip
      user        = var.username
      private_key = file("${var.key_file_path}")
      timeout     = "1m"
    }
  }
  # provisioner "remote-exec" {
  #   inline = [ "sudo sh ${var.docker_init_script["path"]}" ]
  # }


  # user_data              = <<-EOF
  #           #!/bin/bash
  #           sudo apt-get update -y
  #           sudo apt install docker.io -y
  #           sudo usermod -G docker ubuntu
  #           EOF

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "node00-prod"
  }

}

# resource "aws_instance" "node01" {
#   ami           = var.ec2["ami"]
#   instance_type = var.ec2["type"]
#
#   key_name                    = var.ssh_key_name
#   vpc_security_group_ids      = [aws_security_group.production-internal.id]
#   subnet_id                   = data.aws_subnet.prod-subnet.id
#   associate_public_ip_address = false
#
#   user_data = data.template_file.docker_init_tpl.rendered
#
#   root_block_device {
#     volume_size           = "8"
#     volume_type           = "gp2"
#     delete_on_termination = "true"
#   }
#
#   tags = {
#     Name = "node01-prod"
#   }
#
#   lifecycle {
#     create_before_destroy = true
#   }
#
# }

resource "aws_security_group" "production-internal" {
  name        = "production-internal"
  description = "inbound traffic on ports: 22, 80, 8080 for production network"

  vpc_id = data.aws_vpc.production.id

  dynamic "ingress" {
    for_each = var.ingress_ports
    content {
      description = "tcp_${tostring(ingress.value)}"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["${var.local_net}.0/24"]
      #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
    }
  }

  ingress {
    description = "Allow SSH "
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH "
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow All output traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name  = "Internal SG"
    Owner = "VVEldyshev"
    area  = "production"
  }

  # provisioner "remote-exec" {
  #   inline = [
  #     "docker ps",
  #     "docker login 515275369396.dkr.ecr.eu-central-1.amazonaws.com/nginx",
  #     "docker pull 515275369396.dkr.ecr.eu-central-1.amazonaws.com/nginx:0.1",
  #     "docker run -d --name nginx -p 80:80 -p 8080:8080 515275369396.dkr.ecr.eu-central-1.amazonaws.com/nginx:0.1",
  #   ]
  # }

}



output "instance_id" {
  value       = aws_instance.node00.id
  description = "The private IP address of the main server instance."
}

output "instance_pri_ip" {
  value       = aws_instance.node00.private_ip
  description = "The private IP address of the main server instance."
}

output "instance_pub_ip" {
  value       = aws_instance.node00.public_ip
  description = "The private IP address of the main server instance."
}

output "working_zone_names" {
  value = data.aws_availability_zones.working_zone.names
}
