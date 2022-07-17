# Step 01: To verify HashiCorp's GPG signature, and install HashiCorp's Debian package

sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl

# Step 02: Add the HashiCorp GPG key.

curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -

# Step 03: Add the official HashiCorp Linux repository.

sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

# Step 04: Update to add the repository, and install the Terraform CLI.

sudo apt-get update && sudo apt-get install terraform

# Step 05: Verify the installation

terraform -help




Ref: https://learn.hashicorp.com/tutorials/terraform/install-cli
