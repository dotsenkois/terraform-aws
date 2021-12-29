provider "aws" {
  region                  = "eu-north-1"
  shared_credentials_file = "/home/dotsenkois/some_secret_data/aws_keys/dotsenkoiskey.csv"
  profile                 = "dotsenkois"
}

# Find the latest available AMI that is tagged with Component = web
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20211129"]
  }
}


locals {
  web_instance_type_map = {
    stage = "t3.micro"
    prod  = "t3.large"
  }
  web_instance_count_map = {
    stage = 1
    prod  = 2
  }
  instances = {
    "t3.micro" = data.aws_ami.ubuntu.id
    "t3.large" = data.aws_ami.ubuntu.id
  }
}

resource "aws_instance" "count" {
  # for_each = local.instances
  # ami = each.value
  # instance_type = each.key


  ami                  = data.aws_ami.ubuntu.id
  instance_type        = local.web_instance_type_map[prod]
  count                = local.web_instance_count_map[prod]
  cpu_core_count       = "1"
  cpu_threads_per_core = "1"
  tags = {
    Name  = "HelloWorld"
    Autor = "dotsenkois"
  }
  lifecycle {
    create_before_destroy = true
  }

  ebs_block_device {
    delete_on_termination = "true"
    device_name           = "/dev/xvda"
    encrypted             = "false"
    volume_size           = "2"
    volume_type           = "gp2"
  }
}

resource "aws_instance" "foreach" {
  for_each      = local.instances
  ami           = each.value
  instance_type = each.key
}
