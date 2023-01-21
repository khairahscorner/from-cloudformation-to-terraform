variable "tg_arn" {
  type = string
}
variable "lb_sg_id" {
  type = string
}
variable "public_sub_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}
