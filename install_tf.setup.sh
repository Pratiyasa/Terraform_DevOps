sudo useradd -m -s /bin/bash terraform

echo "terraform ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/terraform
sudo chmod 440 /etc/sudoers.d/terraform

sudo visudo -c

sudo su - terraform

sudo dnf install -y awscli

aws --version
