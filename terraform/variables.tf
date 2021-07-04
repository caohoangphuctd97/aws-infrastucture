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
    type = object(
        Name = string
        Created_by = string
    )
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