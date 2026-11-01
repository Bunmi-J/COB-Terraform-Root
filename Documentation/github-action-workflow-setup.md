 # Github Actions Workflow Setup
 This workflow installs the latest version of Terraform CLI and configures the Terraform CLI configuration file with github action Open ID Connect (OIDC) API token mechanism for AWS Cloud services.  On pull request events, this workflow will run `terraform init`, `terraform fmt`, 'terraform validate'and `terraform plan` (speculative plan via AWS Cloud). On push events to the "main" branch, `terraform apply` will be executed.

### Documentation for `hashicorp/setup-terraform` is located here:
 https://github.com/hashicorp/setup-terraform
#
 --  To use this workflow, you will need to complete the following setup steps.
#
### 1. Create a `main.tf`, `outputs.tf`, `variables.tf`, `terraform.tfvars` file in the root of this repository with the `remote` backend and one or more resources defined.
  
*  Example `main.tf`:
*    The configuration for the `remote` backend.
```yaml
     terraform {
       backend "remote" {
         # The setting will vary depending on the cloud service being used. For this project S3 is used for the remote backend. The bucket, key and AWS region are set, substitute values in [] with actual AWS values.on.
        bucket = ["S3 bucket name"]  
        key = ["S3 object path to terraform.tfstate" ]
        region = ["AWS region"] 
        use_lockfile = "true"  

#
#         
       }
     }
#
```
*     An example resource that does nothing.
```yaml
     resource "null_resource" "example" {
       triggers = {
         value = "A example resource that does nothing!"
       }
     }
```
#
#
## 2. Generate a github action OIDC token.
 Github Actions uses OIDC to generate a short-lived token that proves the workflow's authenticity, allowing access to AWS resources without needing to store long-lived credentials. This process ensures that access tokens are allocated predictably, and any workflow from an unauthorized repository is blocked automatically.

**OIDC Configuration Details**

We recommend using GitHub's OIDC provider to get short-lived AWS credentials needed for your actions. When using OIDC, you configure IAM to accept JWTs from GitHub's OIDC endpoint. This action will then create a JWT unique to the workflow run using the OIDC endpoint, and it will use the JWT to assume the specified role with short-term credentials.

To get this to work

* Configure your workflow to use the id-token: write permission.

* Configure your audience, if required.

* In your AWS account, configure IAM to trust GitHub's OIDC identity provider.

* Configure an IAM role with appropriate claim limits and permission scope.

Note: Naming your role "GitHubActions" has been reported to not work. See #953.

Specify that role's ARN when setting up this action.

**OIDC Audience**

When the JWT is created, an audience needs to be specified. Normally, you would use sts.amazonaws.com, and this action uses this by default if you don't specify one. This will work for most cases. Changing the default audience may be necessary when using non-default AWS partitions, such as China regions. You can specify the audience through the audience input:

```yaml
- name: Configure AWS Credentials for China region audience
  uses: aws-actions/configure-aws-credentials@v6.3.0
  with:
    audience: sts.amazonaws.com.cn
    aws-region: cn-northwest-1
    role-to-assume: arn:aws-cn:iam::123456789100:role/my-github-actions-role
```
**Configuring IAM to trust GitHub**

To use GitHub's OIDC provider, you must first set up federation in your AWS account. This involves creating an IAM Identity Provider that trusts GitHub's OIDC endpoint. You can create an IAM Identity Provider in the AWS Management Console by specifying the following details:

* Provider Type: OIDC
* Provider URL: https://token.actions.githubusercontent.com
* Audience: sts.amazonaws.com (or your custom audience if you specified one in the audience input)
Prior versions of this documentation gave instructions for specifying the certificate fingerprint, but this is no longer necessary. The thumbprint, if specified, will be ignored.

**You can also create the IAM Identity Provider using the AWS CLI:**

```
aws iam create-open-id-connect-provider \
    --url https://token.actions.githubusercontent.com \
    --client-id-list sts.amazonaws.com
```    

**Claims and scoping permissions**

To align with the Amazon IAM best practice of granting least privilege, the assume role policy document should contain a Condition that restricts which workflows can assume the role. Without any condition, any GitHub user or repository could potentially assume the role.

GitHub provides a number of additional claims in the OIDC token that you can use in your IAM policies to scope down permissions. Early versions of this action only supported the sub and aud claims, but AWS IAM and GitHub have since added support for sub claim customization and a variety of additional claims (1, 2).

Warning: Avoid ForAllValues: in Allow statements. These operators return true when the claim is absent or misspelled, which can lead to unintended access. Instead, use StringEquals or StringLike operators to check for specific claim values.

**Immutable subject claims**

Repositories created on github.com on or after 15 July 2026, older repositories that have opted in, and older repositories that have been renamed since 15 July 2026, emit an immutable sub claim. This claim appends the permanent numeric ID of the organization and of the repository after each name, separated by @, so that a recycled org or repository name cannot be used to mint tokens matching a stale trust policy. For example:

 **Legacy (mutable) sub claim**
repo:octo-org/octo-repo:ref:refs/heads/main

 **Immutable sub claim**

repo:octo-org@123456/octo-repo@789012:ref:refs/heads/main

If your trust policy matches the legacy name-only form and your repository emits the immutable claim, AssumeRoleWithWebIdentity fails with Not authorized to perform sts:AssumeRoleWithWebIdentity. To fix this, update the sub condition to the immutable form. You can find your repository's prefix in the Settings.


###   Documentation:
     - https://docs.github.com/en/actions/how-tos/secure-your-work/security-harden-deployments/oidc-in-aws
     - https://help.github.com/en/actions/configuring-and-managing-workflows/creating-and-storing-encrypted-secrets
#

## 3. Setup AWS environment and configure the AWS credentials
*   Create an IAM Identity Provider in your AWS account for GitHub OIDC. (See OIDC configuration above for details.)

* Create an IAM Role in your AWS account with a trust policy that allows GitHub Actions to assume it. (Expand the sections below)

Details
Note: The value of the sub claim may be different depending on the workflow and the environment in which it's running. Workflows in repositories created prior to 15 July 2026 will omit the @<ORG_ID> and @<REPO_ID> suffixes unless opted in. Workflows running in GitHub environments will include anenvironment:<ENVIRONMENT_NAME> stanza. See Claims and scoping permissions for more information.

* Attach permissions to the IAM Role that allow it to access the AWS resources you need.

* Add the following to your GitHub Actions workflow:

  **Details**

    Your GitHub Actions workflow can now access AWS resources using the IAM Role you created. Other authentication scenarios are also supported.

 ```yaml
     - name: Configure AWS Credentials
       uses: aws-actions/configure-aws-credentials@v4
       with:
          role-to-assume: arn:aws:iam::1234567891011:role/cob-terraform-github-actions
          aws-region: ${{ secrets.AWS_REGION }}
    
     - name: Verify AWS identity
       run: aws sts get-caller-identity
       
 ```
###   Documentation:
       - https://github.com/aws-actions/configure-aws-credentials#configure-aws-credentials       