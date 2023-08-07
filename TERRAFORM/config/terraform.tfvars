region = "ap-southeast-2"

vpc_config ={
    vpc_main = {
        vpc_cidr_block = "192.168.0.0/16"
        tags           = {
            "Name" = "vpc_main"
        }
    }
}

subnet_config = {
    "public-ap-southeast-2a" = {
        vpc_name = "vpc_main"
        cidr_block = "192.168.0.0/18"
        availability_zone = "ap-southeast-2a"
        tags = {
            Name = "public-ap-southeast-2a"
        }
    }
    "public-ap-southeast-2b" = {
        vpc_name = "vpc_main"        
        cidr_block = "192.168.64.0/18"
        availability_zone = "ap-southeast-2b"
        tags = {
            Name = "public-ap-southeast-2b"
        }
    }
    "private-ap-southeast-2a" = {
        vpc_name = "vpc_main"   
        cidr_block = "192.168.128.0/18"
        availability_zone = "ap-southeast-2a"
        tags = {
            Name = "private-ap-southeast-2a"
        }
    }
    "private-ap-southeast-2b" = {
        vpc_name = "vpc_main"   
        cidr_block = "192.168.192.0/18"
        availability_zone = "ap-southeast-2b"
        tags = {
            Name = "private-ap-southeast-2b"
        }
    }
}


igw_config = {
    igw_main = {
        vpc_name = "vpc_main"
        tags = {
            "Name" = "IGW Main"
        }
    }
}

eip_config = {
    eip01 = {
        tags = {
            "Name" = "nat01"
        }
    }
    eip02 = {
        tags = {
            "Name" = "nat02"
        }
    }
}



nat_gw_config = {
    nat_gw01 = {
        eip_name = "eip01"
        subnet_name = "public-ap-southeast-2a"
        tags = {
            "Name" = "nat_gw01"
        }
    }
    nat_gw02 = {
        eip_name = "eip02"     
        subnet_name = "public-ap-southeast-2b"
        tags = {
            "Name" = "nat_gw02"
        }
    }
}


rt_config ={
    rt_01 = {
        private = 0

        vpc_name = "vpc_main"
        gateway_name = "igw_main"
        tags = {
            "Name" = "Public-Route Table"
        }
    }
    rt_02 = {
        private = 1
        vpc_name = "vpc_main"
        ### Should attach NAT gateway
        gateway_name = "nat_gw01"
        tags = {
            "Name" = "Private-Route Table"
        }
    }
    rt_03 = {
        private = 1
        vpc_name = "vpc_main"
        ### Should attach NAT gateway
        gateway_name = "nat_gw02" 
        tags = {
            "Name" = "Private-Route Table"
        }
    }
}

rta_config={
    rta_01 ={
        subnet_name = "public-ap-southeast-2a"
        route_table_name = "rt_01"
    }
    rta_02 ={
        subnet_name = "public-ap-southeast-2b"
        route_table_name = "rt_01"        
    }
    rta_03 ={
        subnet_name = "private-ap-southeast-2a"
        route_table_name = "rt_02"        
    }
    rta_04 ={
        subnet_name = "private-ap-southeast-2b"
        route_table_name = "rt_03"
    }
}

aws_eks_cluster_config ={
    "key" = {
        eks_cluster_name = "main_cluster"
        subnet1 = "public-ap-southeast-2a"
        subnet2 = "public-ap-southeast-2b"
        subnet3 = "private-ap-southeast-2a"
        subnet4 = "private-ap-southeast-2b"
        tags = {
            "Name" = "main_cluster"
        }
    }
}

aws_eks_node_group_config ={
    "node1" = {
        node_group_name = "node1"
        eks_cluster_name = "key"
        node_iam_role = "eks_node_main01"
        subnet1 = "private-ap-southeast-2a"
        subnet2 = "private-ap-southeast-2b"
        tags = {
            "Name" = "node1"
        }
    }
    "node2" = {
        node_group_name = "node2"
        eks_cluster_name = "key"
        node_iam_role = "eks_node_main02"
        subnet1 = "private-ap-southeast-2a"
        subnet2 = "private-ap-southeast-2b"
        tags = {
            "Name" = "node2"
        }
    }
}