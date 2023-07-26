variable "vpc_cidr" {
  type = string
}
variable "main_vpc_cidr" {
  type = string
}
variable "name" {
  type = string
}

locals {
  main_public_cidrs  = [for i in range(1, 255, 2) : cidrsubnet(var.main_vpc_cidr, 8, i)]
  main_private_cidrs = [for i in range(2, 255, 2) : cidrsubnet(var.main_vpc_cidr, 8, i)]
  public_cidrs  = [for i in range(1, 255, 2) : cidrsubnet(var.vpc_cidr, 8, i)]
  private_cidrs = [for i in range(2, 255, 2) : cidrsubnet(var.vpc_cidr, 8, i)]

  # Creating a public & private subnets in each availability zone
  public_subnet_count  = length(data.aws_availability_zones.available.names)
  private_subnet_count = length(data.aws_availability_zones.available.names)
}

variable "access_ip_v4" {
  type = string
}

variable "access_ip_v6" {
  type = string
}

variable "provider_region" {
  type        = string
  default     = ""
  description = "description"
}
variable "instance_type" {
  type    = string
  default = "t2.micro"
}
variable "key" {
  type        = string
  default     = ""
  description = "description"
}

variable "max_subnets" {
  type        = number
  default     = 3
  description = "the upper limit of the number of public subnets or private subnets separately, it will overwrite the public_subnet_count or private_subnet_count variables"
}


locals {
  security_groups = {
    ssh = {
      name        = "grad-proj-ssh-sg"
      description = "security group for public access"
      ingress = {
        ssh = {
          description      = "allow ssh from our access ip only"
          from             = 22
          to               = 22
          protocol         = "tcp"
          cidr_blocks      = [var.access_ip_v4]
          ipv6_cidr_blocks = [var.access_ip_v6]
        }
      }
    }
    http_https = {
      name        = "grad-proj-http-https-sg"
      description = "security group for public access"
      ingress = {
        http = {
          description      = "allow http traffic from anywhere"
          from             = 80
          to               = 80
          protocol         = "tcp"
          cidr_blocks      = ["0.0.0.0/0"]
          ipv6_cidr_blocks = ["::/0"]
        }
        https = {
          description      = "allow https traffic from anywhere"
          from             = 443
          to               = 443
          protocol         = "tcp"
          cidr_blocks      = ["0.0.0.0/0"]
          ipv6_cidr_blocks = ["::/0"]
        }
      }
    }
    rds = {
      name        = "grad-proj-rds-sg"
      description = "security group for rds"
      ingress = {
        postgres = {
          description      = "allow postgres sql traffic"
          from             = 5432
          to               = 5432
          protocol         = "tcp"
          cidr_blocks      = [var.access_ip_v4]
          ipv6_cidr_blocks = [var.access_ip_v6]
        }
      }
    }
    public = {
      name        = "grad-proj-public-sg"
      description = "security group for public access"
      ingress = {
        public = {
          description      = "allow all traffic from our access ip only"
          from             = 0
          to               = 0
          protocol         = "-1"
          cidr_blocks      = [var.access_ip_v4]
          ipv6_cidr_blocks = [var.access_ip_v6]
        }
      } 
    }   
  }
}

