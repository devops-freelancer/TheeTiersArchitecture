variable "region" {
  type        = string
  default     = "ap-south-1"
}
variable "account" {
  default     = "devops-freelancer"
}

variable "availability-zone" {
type    = list(string)
default = ["ap-south-1a", "ap-south-1b"]
}

variable "main-cidr-block" {
default = "10.0.0.0/16"
}

variable "public-cidr-block" {
type    = list(string)
default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private-cidr-block" {
type = list(string)
default = [ "10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}


variable "ami-id" {
default     = "ami-0108d6a82a783b352"
}

variable "vpc-name" {
default     = "Main-VPC"
}

variable "project-name" {
 default     = "assignment"
}

variable "sshkey" {
 default     = ""
}

variable "instance-type" {
default     = "t2.micro"
}


variable "pub-env" {
 default     = ""
}

variable "port-sshd" {
 default     = "22"
}

variable "internal-sg-name" {
default = "Internal-SG"
}

variable "internet-sg-name" {
default = "Internetfacing-SG"
}


