variable "cidr_block" {
  description = "CIDR block for the subnet"
  type        = string
}

variable "name" {
  description = "Name of the subnet"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the subnet will be created"
  type        = string
}

variable "public" {
  description = "value to set the subnet as public or private"
  type        = bool
}

variable "availability_zone" {
  description = "Availability zone for the subnet"
  type        = string  
}
