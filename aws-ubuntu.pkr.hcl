packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "jyothihome-ubuntu-aws-new9"
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-xenial-16.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

build {
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "file"{
    destination = "~/"
    source = "./index.html"
  }

  provisioner "shell" {
          inline = [
            "echo Installing apache",
            "sudo apt-get update",
            "sudo apt-get install -y apache2",
            "sudo cp ~/index.html /var/www/html/",
            "sudo systemctl start apache2",
            "sudo apt-get install ssh -y",
            "sudo systemctl start sshd",
            "sudo systemctl restart sshd",
          ]
  }
}




