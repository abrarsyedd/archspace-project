# Terraform S3 Static Website

This project uses Terraform to create and configure an AWS S3 bucket for hosting a static website. It automatically uploads all files from a local directory (e.g., `archspace-studio`) into the bucket, sets the correct MIME types, and enables public-read access and static website hosting.

## File Structure

Your project directory should look like this. The `archspace-studio` folder contains all your website's static content (HTML, CSS, JS, images).

## Prerequisites

Before you begin, ensure you have the following installed and configured:

1.  **Terraform**: [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
2.  **AWS CLI**: [Install AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)
3.  **AWS Credentials**: Configure your AWS credentials locally. The easiest way is to run `aws configure`.

    ```bash
    aws configure
    ```

## 🚀 Usage

Follow these steps to deploy your website.

### 1. Initialize Terraform

Navigate to your project's root directory (where `s3.tf` is located) and run `init`. This command downloads the necessary AWS provider.

```bash
terraform init
```

```bash
terraform validate
```
```bash
terraform plan
```
```bash
terraform apply
```
website_endpoint = "[http://archspace-studio-static.s3-website-us-east-1.amazonaws.com](http://archspace-studio-static.s3-website-us-east-1.amazonaws.com)"

```bash
terraform destroy
```

