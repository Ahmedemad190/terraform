module "network" {
    source = "W:/NTI/task3/network"
    vpc_cidr= var.vpc_cidr
    nat_subnet_id = module.network.PublicSubnets_id[0]
    vpc_id= module.network.vpc_id
    pub_subnets= var.pub_subnet
    priv_subnets= var.priv_subnet
    igw_id=module.network.igw_id
    nat_id=module.network.nat_id
}