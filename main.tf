provider "aws" {
  region = "us-east-1"  # Choose your preferred AWS region
}

# Security group to allow SSH and MySQL ports
resource "aws_security_group" "allow_ssh_mysql" {
  name        = "allow_ssh_mysql"
  description = "Allow SSH and MySQL ports"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Open SSH to all IP addresses
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Open MySQL to all IP addresses
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow all outbound traffic
  }

  tags = {
    Name = "Allow SSH and MySQL"
  }
}

# EC2 instance to run Ubuntu and MySQL
resource "aws_instance" "mysql_instance" {
  ami           = "ami-005fc0f236362e99f"  # Amazon Linux 2 AMI for Ubuntu
  instance_type = "t2.micro"
  key_name      = "jenkins"  # Replace with your SSH key name

  security_groups = [aws_security_group.allow_ssh_mysql.name]

  # For an Ubuntu AMI, you can update the AMI ID accordingly.
  ami = "ami-005fc0f236362e99f" # Ubuntu 22.04 LTS AMI ID in us-east-1

  subnet_id = "subnet-0bf7f5962228e85f5"  # Replace with your subnet ID

  # User data to install MySQL
  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y mysql-server
              systemctl start mysql
              EOF

  tags = {
    Name = "MySQL-EC2"
  }
}
