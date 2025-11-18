name           = "eloquent"
vpc_cidr_block = "10.0.0.0/16"
region         = "us-east-1"
ecs_cluster_name = "eloquent-cluster"
public_subnets = [
{
    name              = "public-1a"
    is_private        = false
    cidr_block        = "10.0.1.0/24"
    availability_zone = "us-east-1a"
},
{
    name              = "public-1b"
    is_private        = false
    cidr_block        = "10.0.3.0/24"
    availability_zone = "us-east-1b"
}
]
private_subnets = [
{
    name              = "private-1a"
    is_private        = true
    cidr_block        = "10.0.2.0/24"
    availability_zone = "us-east-1a"
},
{
    name              = "private-1b"
    is_private        = true
    cidr_block        = "10.0.4.0/24"
    availability_zone = "us-east-1b"
}
]