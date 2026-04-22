provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "jenkins_server" {
  ami           = "ami-098e39bafa7e7303d"   # Amazon Linux 2023
  instance_type = "t3.small"
  key_name      = "automatic"

  tags = {
    Name = "jenkins-bluegreen"
  }
}
