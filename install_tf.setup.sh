# Install required packages
sudo dnf install -y dnf-plugins-core

# Add HashiCorp repository
sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo

# Install Terraform
sudo dnf install -y terraform

# Verify installation
terraform version
