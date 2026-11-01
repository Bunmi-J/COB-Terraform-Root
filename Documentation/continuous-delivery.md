# Continuous Delivery - Apply approved changes

### Configure terraform apply job to apply approved changes.

The terraform pipeline triggers the workflow when a pull request is opened/ updated or when code is pushed to certain branches.
Below are the required workflow steps for the Terraform pipeline:

* Checks out the repository.
* Set up Terraform .
* Configure AWS credentials
* Verify AWS Web identity.
* Initialise Terraform using the appropriate backend configuration.
* Download the uploaded plan safely.
* Terraform apply.

After a pull request is approved and merged into the designated deployment branch (main), the pipeline would execute the approved infrastructure change through terraform apply.

**The workflow will:**

* Apply only from the intended branch or deployment trigger.
* Use the correct environment and Terraform state.
* Prevent conflicting deployments against the same state.
* Stop when validation, planning, approval, or other required checks fail.
* Report whether the deployment succeeded or failed.
