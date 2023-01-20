
variable "vpc_id" {
  description = "VPC id"
  type        = string
}

variable "ig_id" {
  description = "internet gateway id"
  type        = string
}
variable "eip_id" {
  description = "EIP address allocation id"
  type        = string
}

variable "public_sub_ids" {
  type    = list(string)
  default = ["a", "b"]
}
variable "private_sub_ids" {
  type    = list(string)
  default = ["a", "b"]
}

# variable "launch_config_ami" {
#   description = "Image id for launch config"
#   type = string
# }
# variable "instance_type" {
#   description = "Instance type in launch config"
#   type = string
# }
