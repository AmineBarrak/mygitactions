# Step 1: Specify the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Step 2: Create a Security Group (HTTP only)
resource "aws_security_group" "demo_sg" {
  name_prefix = "demo-sg-"
  description = "Allow HTTP inbound traffic"

  ingress {
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
    Name = "Terraform-Demo-SG"
  }
}

# Step 3: Launch the EC2 Instance (no SSH key needed)
resource "aws_instance" "demo_ec2" {
  ami                    = "ami-08c40ec9ead489470"  # Ubuntu 22.04 LTS (us-east-1)
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.demo_sg.id]

  tags = {
    Name = "Terraform-Demo-EC2"
  }
}

# Step 4: Outputs
output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.demo_ec2.public_ip
}
