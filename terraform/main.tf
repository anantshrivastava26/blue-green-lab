provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "jenkins_server" {
  ami           = "ami-0f58b397bc5c1f2e8"   # Ubuntu 22.04 (update if needed)
  instance_type = "t2.medium"
  key_name      = "your-keypair"

  tags = {
    Name = "jenkins-bluegreen"
  }
}
