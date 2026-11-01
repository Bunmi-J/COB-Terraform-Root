# Continuous Integration

Whenever a pull request changes Terraform code, the pipeline automatically:

* Checks out the repository.
* Set up Terraform .
* Configure AWS credentials
* Verify AWS Web identity.
* Initialise Terraform using the appropriate backend configuration.
* Check Terraform formatting.
* Run terraform validate.
* Generate a Terraform plan.
* Publish the plan in a way that reviewers can inspect it safely.
* The pipeline must fail when required checks fail. An Engineer should not be able to merge a change simply because the Terraform code looks correct.

