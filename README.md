# AWS_Infrastructure_with_Terraform
CI/CD Practice.

In this push,I added new resources for ECR, IAM, and OIDCprovider.(2025/12/12 commit)

After running `terraform apply -auto-approve`, verify in the AWS Management Console that the connection to GitHub using OpenID Connect has been established in the IAM service management screen.
(※Image 1: Identity provider section
     Image 2: Identity provider details)
<img width="1912" height="739" alt="OIDC1" src="https://github.com/user-attachments/assets/1d88542d-21ce-435e-a141-2fb573eb7ae9" />
<img width="1439" height="559" alt="OIDC2" src="https://github.com/user-attachments/assets/7d30ba4f-114a-4bbe-80f0-f9c6f8cbe28b" />
