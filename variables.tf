# define general variables 

variable "environment_name" {
  description = "Environment name"
  type        = string
  default     = "UdacityProject-2"
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}
variable "ami" {
  type = string
}
