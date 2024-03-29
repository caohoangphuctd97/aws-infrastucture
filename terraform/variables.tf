variable project_region {
    type = string
    default = "ap-southeast-1"
}

variable bucket {
    type = string
}

variable region {
    type = string
}

variable tags {
    type = object({
        Name_project = string,
        Created_by = string
    })
}

variable cidr_block {
    type = string
}

variable enable_dns_support {
    type = string
}

variable enable_dns_hostnames {
    type = string
}

variable enable_classiclink {
    type = string
}

variable instance_tenancy {
    type = string
}

// Subnet //
variable cidr_public_subnet {
    type = string
    default = "10.0.1.0/24"
}

variable availability_zone {
    type = string
}

// EC2 //
variable PRIVATE_KEY_PATH {
    type = string
}

variable PUBLIC_KEY_PATH {
    type = string
}

variable ec2_user {
    type = string
}

variable "cert" {
    type = string
}