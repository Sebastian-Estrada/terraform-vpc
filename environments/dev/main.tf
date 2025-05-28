module "vpc" {
  source         = "../../modules/vpc"
  name           = "vpc-dev"
  vpc_cidr_block = var.vpc_cidr_block
}

module "public_subnet" {
  source            = "../../modules/subnet"
  name              = "public-subnet-dev"
  vpc_id            = module.vpc.vpc_id
  cidr_block        = var.cidr_block
  availability_zone = var.availability_zone
  public            = true
}