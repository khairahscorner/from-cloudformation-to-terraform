
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
  type = list(string)
}
variable "private_sub_ids" {
  type = list(string)
}
