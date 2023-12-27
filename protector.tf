resource "aws_security_group" "internetfacing-alb-sg" {
   name        = var.internet-sg-name
   vpc_id      = aws_vpc.main-vpc.id
   ingress {
      description      = "HTTP Access"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }
   
    ingress {
      description      = "HTTPS Access"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }
   
    ingress {
      description      = "ssh Access"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }
   
    egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
    }
  tags = { 
            Name = var.internet-sg-name
         }
}

resource "aws_security_group" "internal-alb-sg" {
   name        = var.internal-sg-name
   vpc_id      = aws_vpc.main-vpc.id
  
    ingress {
      description      = "ssh Access"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }
   
    egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
    }
  tags = { 
             Name = var.internal-sg-name
         }
}