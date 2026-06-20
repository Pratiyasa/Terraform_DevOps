
### With Public IP Address ###


variable public_ip{
	default="true"
}

resource "aws_instance" "myserver" {

  ami           = "ami-0f918f7e67a3323f0" # Amazon Linux (example)
  instance_type = "t3.micro"

  associate_public_ip_address = var.public Ip

  tags = {
    Name = "server1"
  }
}



### Without Public IP Adrress ###


variable public_ip{
	default="false"
}

resource "aws_instance" "myserver" {

  ami           = "ami-0f918f7e67a3323f0" # Amazon Linux (example)
  instance_type = "t3.micro"

   subnet_id = "subnet-0a12bc34de56fg789"

  associate_public_ip_address = var.public_ip

  tags = {
    Name = "server1"
  }
}