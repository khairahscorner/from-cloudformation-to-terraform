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
