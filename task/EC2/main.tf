resource "aws_instance" "web" {
  count         = var.instance_count
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = "aws_key"
  subnet_id     = element([aws_subnet.PublicSubnet.id, aws_subnet.PublicSubnet_2.id], count.index)  # Alternate between the two public subnets
  vpc_security_group_ids = [aws_security_group.sg_8080.id] 
  

  # Remote-exec provisioner to install Apache
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y apache2",
      "sudo systemctl start apache2",
      "sudo systemctl enable apache2"
    ]

    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ubuntu"
      private_key = file("id_rsa")
    }
  }


  provisioner "local-exec" {
    command = <<EOT
      echo "public-ip${count.index + 1} ${self.public_ip} : ${self.private_ip}" >> all-ips.txt
    EOT
  }

  tags = {
    Name = "web_instance_${count.index + 1}"
  }
}


resource "aws_key_pair" "devloyper" {
    key_name = "aws_key"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCqHUCSLsDUd/ykyKWEnXSp0Q1wHphcmbQwBgnpJty55ZbwVUO9Zx0z/XSQyu0Nun3A9BdCTsXtjKS7yd/deaG9yQ+Dvy7/zQbIxS9GD77JBMd4rNQmRYYAoXrEyrg4ksDzHei7rropOSEc0INgfEPVuw1JibmbaZF/Gr4cKqxYXAK+v6ihKHkCr4ZBN+sg8OkMGxsGa+ZKaHZTiyPzONa5UeeXJd3NTE3FxO0QRWiuZSJ1I8W9PasXdwnYH4YkbZIiPMY0aWGxkIdzXjZTv4RSOkThDCxcyJ2PjeI09w50AaNW41Ubwwcs3q4lXu/UMsBrkwP+/rASQrFDOUtHUwCf emad@DESKTOP-M7NGHGA"
  
}
resource "aws_instance" "private_instance" {
    ami               = var.ami
    count             = 2
    instance_type     = var.instance_type
    key_name          = "aws_key"
    subnet_id         = element([aws_subnet.private_subnet.id, aws_subnet.private_subnet_2.id], count.index)
    vpc_security_group_ids = [aws_security_group.sg_8080.id] 
    associate_public_ip_address = false

      tags = {
    Name = "web_instance_private${count.index + 1}"
  }
}
