variable "vpc_id" {
  type = string
}
variable "ig_id" {
  type = string
}
variable "zone_identifiers" {
  type = list(string)
}

variable "launch_ami" {
  description = "Image id for launch template"
  type        = string
}
variable "instance_type" {
  description = "Instance type in launch template"
  type        = string
}
variable "key_name" {
  type = string
}
