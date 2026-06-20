# Terraform + AWS CLI Setup on Amazon Linux

## Step 1: Install Required Packages

Install DNF plugin utilities.

```bash
sudo dnf install -y dnf-plugins-core
```

Purpose:

* Enables repository management using `config-manager`.

---

## Step 2: Add HashiCorp Repository

Add the official HashiCorp repository to install Terraform.

```bash
sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
```

Purpose:

* Adds Terraform package source to Amazon Linux.

---

## Step 3: Install Terraform

Install Terraform.

```bash
sudo dnf install -y terraform
```

Verify installation:

```bash
terraform version
```

Expected Output:

```text
Terraform vX.X.X
```

Purpose:

* Confirms Terraform is installed successfully.

---

## Step 4: Create Dedicated Terraform User

Create a separate Linux user for Terraform operations.

```bash
sudo useradd -m -s /bin/bash terraform
```

Options:

* `-m` → Create home directory
* `-s` → Set shell

Purpose:

* Separates infrastructure operations from root user.

---

## Step 5: Grant Sudo Access

Allow Terraform user to execute commands without password.

```bash
echo "terraform ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/terraform
```

Set proper permissions:

```bash
sudo chmod 440 /etc/sudoers.d/terraform
```

Validate sudo configuration:

```bash
sudo visudo -c
```

Expected:

```text
/etc/sudoers: parsed OK
```

Purpose:

* Enables secure administrative access.

---

## Step 6: Switch to Terraform User

Move into Terraform user account.

```bash
sudo su - terraform
```

Verify:

```bash
whoami
```

Expected:

```text
terraform
```

---

## Step 7: Install AWS CLI

Install AWS CLI.

```bash
sudo dnf install -y awscli
```

Verify:

```bash
aws --version
```

Expected:

```text
aws-cli/X.X.X
```

Purpose:

* Allows Terraform to authenticate and manage AWS resources.

---

## Step 8: Configure AWS CLI

Configure credentials.

```bash
aws configure
```

Enter:

```text
AWS Access Key ID
AWS Secret Access Key
Region → ap-south-1
Output Format → json
```

Verify:

```bash
aws sts get-caller-identity
```

Expected:

```json
{
  "Account": "xxxxxxxxxxxx",
  "Arn": "arn:aws:iam::xxxxxxxxxxxx:user/terraform-user"
}
```

---

## Step 9: Verify Terraform Access

Create a test file.

```bash
touch main.tf
```

Initialize:

```bash
terraform init
```

Expected:

```text
Terraform has been successfully initialized
```

---

## Installed Components

* Terraform
* AWS CLI
* Dedicated terraform user
* Sudo configuration
* AWS authentication

Environment is now ready for Terraform deployments.
