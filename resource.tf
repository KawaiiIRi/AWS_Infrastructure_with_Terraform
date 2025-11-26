module "vpc" {
  source         = "./modules/vpc"
  service_name   = "sample"
  env            = terraform.workspace
  vpc_cidr_block = "10.0.0.0/16"
  vpc_additional_tags = {
    Usage = "sample vpc explanation"
  }

subnet_cidrs = {
  public  = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
  private = ["10.0.100.0/24", "10.0.101.0/24", "10.0.102.0/24"]
}
}