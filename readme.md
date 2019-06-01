Steps:

Install AWS CLI or use Amazon linux which has cli installed

> aws configure

Install Terraform

 https://www.terraform.io/downloads.html
 download 32 bit linux

Generate SSH keys in the name 'terraform' and place it in /root/.ssh

Navigate to infra folder and run terraform

terraform init

terraform plan --var-file variables/demo-oh.tfvars

terraform apply --var-file variables/demo-oh.tfvars

terraform destroy --var-file variables/demo-oh.tfvars

