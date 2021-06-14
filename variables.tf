variable "aws_access_key" {
    description = "AWS Access key"
}

variable "aws_secret_key" {
    description = "AWS Secret key"
}

variable "aws_region" {
    description = "EC2 Region for the VPC"
}

variable "ubuntu_ami" {
    description = "AMIs by region"
    default = {
        eu-central-1 = "ami-05f7491af5eef733a" # ubuntu 20.04 LTS
    }
}

variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
    description = "CIDR for the Public Subnet"
    default = "10.0.0.0/24"
}

variable "private_subnet_cidr" {
    description = "CIDR for the Private Subnet"
    default = "10.0.1.0/24"
}