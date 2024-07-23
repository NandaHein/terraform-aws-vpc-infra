variable "config_file" {
  description = "config_file."
  type        = list(string)
  default     = ["/home/nanda/.aws/config"]
}

variable "creds_file" {
  description = "creds_file."
  type        = list(string)
  default     = ["/home/nanda/.aws/credentials"]
}

variable "aws_region_01" {
  description = "aws_region."
  type        = string
  default     = "ap-south-1"
}

variable "profile_01" {
  description = "aws_profile_01."
  type        = string
  default     = "grit-cloudnanda"
}

variable "aws_admin_role" {
  description = "aws_admin_role_for_prod_account."
  type        = string
  default     = "arn:aws:iam::112281322679:role/admin-access-01"
}

variable "vpc_cidr_block" {
  description = "vpc cidr block"
  type        = string
  default     = "10.1.0.0/16"
}

variable "vpc_name" {
  description = "your vpc name"
  type        = string
  default     = "custom-vpc-01"
}

variable "igw_name" {
  description = "your internet gateway name"
  type        = string
  default     = "custom-igw-01"
}

variable "private_route_table_name" {
  description = "your private route table name"
  type        = string
  default     = "private-route-table"
}

variable "public_subnets" {
  description = "public subnets information"
  type        = map(any)
  default = {
    public_subnet_01 = {
      cidr_block        = "10.1.0.0/24"
      availability_zone = "ap-south-1a"
    }
    public_subnet_02 = {
      cidr_block        = "10.1.1.0/24"
      availability_zone = "ap-south-1b"
    }
  }
}

variable "private_subnets" {
  description = "private subnets information"
  type        = map(any)
  default = {
    private_subnet_01 = {
      cidr_block        = "10.1.2.0/24"
      availability_zone = "ap-south-1a"
    }
    private_subnet_02 = {
      cidr_block        = "10.1.3.0/24"
      availability_zone = "ap-south-1b"
    }
  }
}

variable "bastion_host_sg_name" {
  description = "bastion host security group name"
  type        = string
  default     = "bastion_host_sg"
}

variable "bastion_host_key_name" {
  description = "your bastion host key name"
  type        = string
  default     = "bastion_host"
}

variable "bastion_host_instance_type" {
  description = "bastion host instance type"
  type        = string
  default     = "t2.micro"
}

variable "private_instance_instance_type" {
  description = "private_instance instance type"
  type        = string
  default     = "t2.micro"
}

variable "local_ssh_key_path" {
  description = "your private key path to stored"
  type        = string
  default     = "./bastion_host.pem"
}