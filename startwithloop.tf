provider "aws" {
    region = "eu-north-1"
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
}

resource "aws_instance" "EC2-Instance"{
    availability_zone = "eu-north-1a"
    ami = "ami-0989fb15ce71ba39e"
    instance_type = "t3.micro"
    key_name = "oleg1"
    vpc_security_group_ids =  [aws_security_group.DefaultTerraformSG.id]

    ebs_block_device {
        device_name = "/dev/sda1"
        volume_size = 10
        volume_type = "standard"
        tags = {
        Name = "root-disk"
      }
    }
    user_data = file("install.sh")

    tags = {
        Name = "EC2-Instance"
    }
}

resource "aws_security_group" "DefaultTerraformSG" {
    name="DefaultTerraformSG"
    description = "uff - 165 social credit"

    dynamic "ingress" {
      for_each = ["80", "443", "161", "10050", "10051", "3306", "3369", "55555", "4444", "333", "8080", "8000"]
      content {
        from_port = ingress.value
        to_port = ingress.value
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    }
      ingress {
        description = "Allow 22"
        from_port = 22
        to_port= 22
        protocol = "tcp"
        cidr_blocks = ["194.44.93.225/32"]
    }

    egress {
        description = "Allow ping"
        from_port = 0
        to_port= 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    
  
}
