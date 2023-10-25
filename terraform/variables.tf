variable "aws_region" {
  description = "The AWS region where resources will be created."
  default     = "eu-north-1"
}

variable "instance_type_kube_master" {
  description = "The instance type for the kube_master EC2 instance."
  default     = "t3.medium"
}

variable "ami_id_t3_medium" {
  description = "The ID of the AMI to use for EC2 instances."
  default     = "ami-08766f81ab52792ce"
}

variable "kube_node" {
  description = "The instance type for the kube_master EC2 instance."
  default     = "t3.micro"
}

variable "ami_id_t3_micro" {
  description = "The ID of the AMI to use for EC2 instances."
  default     = "ami-08766f81ab52792ce"
}

variable "key_name" {
  description = "The name of the SSH key pair."
  default     = "accesspair"
}

variable "ssh_user" {
  description = "The SSH user for EC2 instances."
  default     = "ubuntu"
}


variable "private_key_file" {
  description = "The path to the private key file for SSH access."
  default     = "C:\\pair\\accesspair.pem"
}


variable "kube_node_count" {
  description = "The number of kube_node instances to create."
  default     = 2
}