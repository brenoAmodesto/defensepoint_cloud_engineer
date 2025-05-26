##### VPC - DEV

module "vpc-dev" {
  source = "./vpc/vpc-dev"

  vpc_cidr              = "10.10.0.0/16"
  public_subnet_a_cidr  = "10.10.1.0/24"
  public_subnet_b_cidr  = "10.10.2.0/24"
  private_subnet_a_cidr = "10.10.101.0/24"
  private_subnet_b_cidr = "10.10.102.0/24"
  az_a                  = "us-east-1a"
  az_b                  = "us-east-1b"
  environment           = "dev"
}

##### Security Group - DEV

module "sg-dev" {
  source = "./security_groups/security_group_dev"
  vpc_id = module.vpc-dev.vpc_id
  sg_name = "wazuh_dev_sg"

  ingress_rules = [] # No inbound rules defined

  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound"
    }
  ]
}

### Module IAM SSM Wazuh - DEV

module "iam_ssm-dev" {
  source                = "./iam/iam_wazuh_dev"
  role_name             = "wazuh-ssm-role"
  instance_profile_name = "wazuh-ssm-profile"
}


#### EC2 - DEV - Wazuh

module "ec2-wazuh-dev" {
  source = "./ec2/ec2_dev"

  ami_id                = "ami-0c55b159cbfafe1f0" # Substitua pela AMI correta
  instance_type         = "t3.xlarge"
  subnet_id             = module.vpc-dev.private_subnet_ids[0]
  security_group_ids    = [module.sg-dev.security_group_id]
  iam_instance_profile  = module.iam_ssm-dev.instance_profile_name
}