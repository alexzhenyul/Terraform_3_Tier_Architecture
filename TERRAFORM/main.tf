module "aws_vpc"{
    source = "./modules/aws_vpc"

    for_each = var.vpc_config
    vpc_cidr_block = each.value.vpc_cidr_block
    tags = each.value.tags

}

module "aws_subnet"{
    source = "./modules/aws_subnet"

    for_each = var.subnet_config
    vpc_id = module.aws_vpc[each.value.vpc_name].vpc_id
    cidr_block = each.value.cidr_block
    availability_zone = each.value.availability_zone
    tags = each.value.tags
}

module "aws_igw"{
    source = "./modules/aws_igw"
    for_each = var.igw_config
    vpc_id = module.aws_vpc[each.value.vpc_name].vpc_id
    tags = each.value.tags
}

module "aws_nat_gw"{
    source = "./modules/aws_nat_gw"
    for_each = var.nat_gw_config    
    elastic_IP_id = module.aws_eip[each.value.eip_name].elastic_IP_id
    subnet_id = module.aws_subnet[each.value.subnet_name].subnet_id
    tags = each.value.tags
}

module "aws_eip"{
    source = "./modules/aws_eip"
    for_each = var.eip_config
    tags = each.value.tags
}

module "aws_route_table"{
    source = "./modules/aws_route_table"
    for_each = var.rt_config
    vpc_id = module.aws_vpc[each.value.vpc_name].vpc_id
    ### If route table is public, attach internet gateway, or route table is private, attach nat gateway
    ### terraform.tfvars file (rt_config section adding private = 0/1)
    ### Apply condition
    internet_gateway_id =  each.value.private == 0 ? module.aws_igw[each.value.gateway_name].internet_gateway_id : module.aws_nat_gw[each.value.gateway_name].aws_nat_gateway_id
    tags = each.value.tags
}

module "aws_route_table_association"{
    source = "./modules/aws_route_table_association"
    for_each = var.rta_config
    subnet_id = module.aws_subnet[each.value.subnet_name].subnet_id
    route_table_id = module.aws_route_table[each.value.route_table_name].route_table_id
}

module "aws_eks" {
    source = "./modules/aws_eks"
    for_each = var.aws_eks_cluster_config
    eks_cluster_name = each.value.eks_cluster_name
    subnet_ids = [module.aws_subnet[each.value.subnet1].subnet_id, module.aws_subnet[each.value.subnet2].subnet_id, module.aws_subnet[each.value.subnet3].subnet_id, module.aws_subnet[each.value.subnet4].subnet_id]
    tags = each.value.tags
}

module "aws_eks_node_group"{
    source = "./modules/aws_eks_node_group"
    for_each = var.aws_eks_node_group_config
    node_group_name = each.value.node_group_name
    ## Keep application run in private subnet
    eks_cluster_name = module.aws_eks[each.value.eks_cluster_name].eks_cluster_name
    subnet_ids = [module.aws_subnet[each.value.subnet1].subnet_id, module.aws_subnet[each.value.subnet2].subnet_id]
    node_iam_role = each.value.node_iam_role
    tags = each.value.tags
}






