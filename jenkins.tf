
resource "aws_security_group" "jenkins-sg" {
  name        = "security-group-jenkins"
  description = "Allow traffic to jenkins server"
  vpc_id      = aws_vpc.main_vpc.id
  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Allow http and ssh"
  }
}
resource "aws_instance" "jenkins" {
  ami                    = var.jenkins_ami_id
  instance_type          = var.jenkins_instance_type
  vpc_security_group_ids = [aws_security_group.jenkins-sg.id]
  iam_instance_profile   = aws_iam_instance_profile.jenkins_profile.name
  key_name               = "aws-keypair"
  subnet_id              = aws_subnet.public_subnet[0].id
  private_ip             = "10.0.0.11"
  tags = {
    Name     = "Jenkins",
    START_ME = "true",
    STOP_ME  = "true"
  }
}

resource "aws_iam_instance_profile" "jenkins_profile" {
  name = "jenkins_profile"
  role = aws_iam_role.jenkins_ecr_role.name
}

resource "aws_eip" "lb" {
  instance                  = aws_instance.jenkins.id
  associate_with_private_ip = "10.0.0.11"
  depends_on                = ["aws_internet_gateway.gw"]
}
