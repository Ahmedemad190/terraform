resource "aws_instance" "example" {
    ami = "ami-0866a3c8686eaeeba"
    instance_type = var.instance_type
    tags = {
     Name  = "yt_test" 
    } 
}

output "my_console_op" {
    value = aws_instance.example.public_ip
  
}


module "webserver" {
    source = ".//module-1"
  
}

resource "aws_key_pair" "devloyper" {
    key_name = "aws_key"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCqHUCSLsDUd/ykyKWEnXSp0Q1wHphcmbQwBgnpJty55ZbwVUO9Zx0z/XSQyu0Nun3A9BdCTsXtjKS7yd/deaG9yQ+Dvy7/zQbIxS9GD77JBMd4rNQmRYYAoXrEyrg4ksDzHei7rropOSEc0INgfEPVuw1JibmbaZF/Gr4cKqxYXAK+v6ihKHkCr4ZBN+sg8OkMGxsGa+ZKaHZTiyPzONa5UeeXJd3NTE3FxO0QRWiuZSJ1I8W9PasXdwnYH4YkbZIiPMY0aWGxkIdzXjZTv4RSOkThDCxcyJ2PjeI09w50AaNW41Ubwwcs3q4lXu/UMsBrkwP+/rASQrFDOUtHUwCf emad@DESKTOP-M7NGHGA"
  
}