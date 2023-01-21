terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.34.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "setup" {
  source = "./modules/setup"

  #variable initialised here must have been declared in the variables file for the module
  environment_name = var.environment_name
}

module "routes" {
  source = "./modules/routes"

  # can access other configs from other modules directly like this but terraform flags as error
  # nat_id = module.setup.aws_internet_gateway.internet_gateway.id

  # or via outputs declared in their outputs file
  vpc_id          = module.setup.vpc_id
  ig_id           = module.setup.ig_id
  eip_id          = module.setup.eip_id
  public_sub_ids  = module.setup.public_subnet_ids
  private_sub_ids = module.setup.private_subnet_ids
}

module "security" {
  source = "./modules/security"

  vpc_id = module.setup.vpc_id
}

module "autoscaling" {
  source = "./modules/autoscaling"

  launch_ami    = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_id = module.setup.vpc_id

  iam_profile      = module.security.profile
  ec2_sg_id        = module.security.app_sg
  lb_sg_id         = module.security.lb_sg
  zone_identifiers = module.setup.private_subnet_ids
}

module "load-balancing" {
  source = "./modules/load-balancing"

  tg_arn         = module.autoscaling.target_gp_arn
  lb_sg_id       = module.security.lb_sg
  public_sub_ids = module.setup.public_subnet_ids
  vpc_id         = module.setup.vpc_id
}
