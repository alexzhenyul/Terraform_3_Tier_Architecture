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
    vpc_id = ""
    tags = ""
}

module "aws_route_table"{
    source = "./modules/aws_route_table"
    vpc_id = ""
    gateway_id = ""
    tags = ""
}

module "aws_route_table_association"{
    source = "./modules/aws_route_table_association"
    subnet_id = ""
    route_table_id = ""
}