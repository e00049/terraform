# Terraform core commands: 
### terraform -help             - Show this help output, or the help for a specified subcommand.
### terraform -version          - An alias for the "version" subcommand.
### terraform init              - terraform init
### terraform init --upgrade    - upgrade or downgrade
### terraform fmt               - terraform format
### terraform validate          - validate the file
### terraform plan              - what we gonna create 
### terraform apply             - create the resources 
### terraform destory           - delete the resources 
### terraform import            - import the existing 
### terraform graph graph.svg   - make project as graph format
### terraform state list        - list out resources created
### terraform rm aws_intace.my_instance            --> my instance will not managed by terraform
### terraform apply -target aws_intace.my_instance --> create perticular module
### terraform -chdir=/which/project/dir            --> which project files have to execute.** -->
