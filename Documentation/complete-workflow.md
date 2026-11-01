
## This pipeline demonstrates workflows using real changes to COB data platform.

### - Valid infrastructure change
Add a resource or change a configuration. Open a pull request, inspect the checks and plan, merge the approved change, and demonstrate that the pipeline applies it.

 **COB Plan**

![Screenshot](../Images/valid-infrastructure.jpg)


**COB Apply**

![Screenshot](../Images/valid-applied-infrastructure.jpg)


**Terraform Apply**

![Screenshot](../Images/terraform-apply.jpg)




### - Invalid Terraform

Introduce a deliberate configuration error in a separate branch. Show that the pipeline detects the problem and prevents the deployment.

![Screenshot](../Images/invalid-terraform.jpg)

![Screenshot](../Images/failed.jpg)



### - Repeatability

Run the workflow again when no infrastructure changes are required. Observe the resulting plan and demonstrate that your pipeline handles an unchanged environment sensibly.

![Screenshot](../Images/valid-applied-infrastructure1.jpg)


