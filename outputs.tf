output "aws_vpc_id" {
  value       = aws_vpc.custom-vpc-01.id
  description = "The information of created aws vpc id."
}

output "aws_elastic_ip_address" {
  value       = aws_eip.bastion_host_elastic_ip.public_ip
  description = "The information of aws elastic ip address."
}

output "aws_bastion_host_ssh_connect" {
  value       = "ssh -i ${var.local_ssh_key_path} ec2-user@${aws_eip.bastion_host_elastic_ip.public_ip}"
  description = "The information of bastion host ssh connection."
}

output "aws_private_instance_ssh_connect" {
  value       = "ssh -i ${aws_key_pair.aws_ec2_key_pairs.key_name}.pem ec2-user@${aws_instance.private_instance.private_ip}"
  description = "The information of private instance ssh connection."
}