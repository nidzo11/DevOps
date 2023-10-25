provider "aws" {
  region = var.aws_region
}

# VPC setup
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}


resource "aws_security_group" "vpc-web" {
  name        = "vpc-web-${terraform.workspace}"
  vpc_id      = aws_vpc.main.id
  description = "Web Traffic"
  ingress {
    description = "Allow Port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow Port 443"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
  }
  egress {
    description = "Allow all ip and ports outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_subnet" "subnet_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}


resource "aws_internet_gateway" "gate-1" {
  vpc_id = aws_vpc.main.id
}


resource "aws_default_route_table" "default" {
  default_route_table_id = aws_vpc.main.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gate-1.id
  }
}


resource "aws_security_group" "ec2_sg" {
  name   = "allow-all-ssh"
  vpc_id = aws_vpc.main.id
  # SSH
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  # Kubernetes API
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
  }

  # etcd
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 2379
    to_port     = 2380
    protocol    = "tcp"
  }

  # Kubelet API
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
  }

  # kube-scheduler
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 10251
    to_port     = 10251
    protocol    = "tcp"
  }

  # kube-controller-manager
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 10252
    to_port     = 10252
    protocol    = "tcp"
  }

  # NodePort Services
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 179
    to_port     = 179
    protocol    = "tcp"
  }


  ingress {
    description = "Allow all traffic between nodes"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }
  # Terraform removes the default rule
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


}


# IAM Role for EC2 Instances
resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Effect = "Allow",
      }
    ]
  })
}

resource "aws_iam_policy" "ebs_management" {
  name        = "EBSManagement"
  description = "Policy to allow EC2 instances to manage EBS volumes"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "ec2:CreateVolume",
          "ec2:DeleteVolume",
          "ec2:DescribeVolumes",
          "ec2:AttachVolume",
          "ec2:DetachVolume",
          "ec2:DescribeInstances",
          "ec2:DescribeVolumeStatus",
          "ec2:CreateSnapshot",
          "ec2:DeleteSnapshot",
          "ec2:DescribeSnapshots",
          "ec2:CreateTags",
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:CreateGrant",
          "kms:RevokeGrant"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

# Attach the policy to the EC2 role
resource "aws_iam_role_policy_attachment" "ebs_attachment" {
  policy_arn = aws_iam_policy.ebs_management.arn
  role       = aws_iam_role.ec2_role.name
}



# EC2 instances
resource "aws_instance" "kube_master" {
  instance_type          = var.instance_type_kube_master
  ami                    = var.ami_id_t3_medium
  key_name               = var.key_name
  subnet_id              = aws_subnet.subnet_a.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id, aws_security_group.vpc-web.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  tags = {
    Name = "KubeMaster"
  }
}
resource "null_resource" "kube_master_provisioner" {
  # Ensuring this provisioner runs after kube_master is created
  triggers = {
    kube_master_id = aws_instance.kube_master.id
  }

  connection {
    type        = "ssh"
    user        = var.ssh_user
    private_key = file(var.private_key_file)
    host        = aws_instance.kube_master.public_ip
  }

  provisioner "file" {
    source      = "C:\\DevOps\\DevOps\\terraform\\scripts\\master.sh"
    destination = "/tmp/master.sh"
  }

  provisioner "file" {
    source      = var.private_key_file
    destination = "/home/ubuntu/.ssh/id_rsa"
  }




  provisioner "remote-exec" {

    inline = [
      "chmod 600 /home/ubuntu/.ssh/id_rsa",
      "chmod +x /tmp/master.sh",
      "KUBE_NODE_IPS=\"${join(",", aws_instance.kube_node.*.public_ip)}\" /tmp/master.sh"
    ]
  }
}



resource "aws_instance" "kube_node" {
  depends_on             = [aws_instance.kube_master]
  count                  = var.kube_node_count
  instance_type          = var.kube_node
  ami                    = var.ami_id_t3_micro
  key_name               = var.key_name
  subnet_id              = aws_subnet.subnet_a.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  tags = {
    Name = "KubeNode-${count.index}"
  }
}

resource "null_resource" "kube_node_provisioner" {
  count = var.kube_node_count


  triggers = {
    kube_node_id               = aws_instance.kube_node[count.index].id
    kube_master_provisioner_id = null_resource.kube_master_provisioner.id
  }

  connection {
    type        = "ssh"
    user        = var.ssh_user
    private_key = file(var.private_key_file)
    host        = aws_instance.kube_node[count.index].public_ip
  }

  provisioner "file" {
    source      = "C:\\DevOps\\DevOps\\terraform\\scripts\\worker.sh"
    destination = "/tmp/worker.sh"
  }


  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/worker.sh",
      "/tmp/worker.sh",
    ]
  }
}

resource "aws_iam_instance_profile" "ec2_profile" {
  role = aws_iam_role.ec2_role.name
}
