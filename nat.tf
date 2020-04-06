
resource "aws_instance" "nat_instance" {
  ami           = "ami-0236d0cbbbe64730c"
  instance_type = "t3.micro"
  key_name      = "aws-keypair"
  subnet_id     = aws_subnet.public_subnet[1].id
  private_ip    = "10.0.1.11"
  tags = {
    Name     = "Nat",
    START_ME = "true",
    STOP_ME  = "true"
  }
}
