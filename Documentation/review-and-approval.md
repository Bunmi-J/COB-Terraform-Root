## Review and Approval

### Set Up Environment Protection Rules

**Deployment Protection Rules for Prod and Dev Environment**

Configure reviewers, timers, and custom rules that must pass before deployments to production and dev environments can proceed.

* Prod environment: Protected branches only
  - Allow administrators to bypass configured protection rules is disabled
  - Required reviewer set to 2
  - Prevent self-review,this requires a different approver than the user who triggered the workflow run.

*  Dev environment- Selected branches
   - Main and Pull request can deploy to this environment
   - Allow administrators to bypass configured protection rules is enabled

### Review

Infrastructure changes can create resources, destroy resources, expose services, or increase cloud costs.

The CI/CD pipeline therefore makes the proposed changes visible for reviewers before they are applied. You can specify to upload the proposed plan using the following yaml block.

```yaml
- name: Upload Plan Artifact
      uses: actions/upload-artifact@v4
      with:
        name: cobplan
        path: cobplan
```


Review process allows an authorised person to inspect the plan, approve or suggest changes to the deployment where appropriate. The review process is implemented by setting up ruleset that creates a trigger to run the workflow once the proposed changes are approved. Go to settings, then rulesets and configure the rulesets.

**Ruleset for Main branch**
* Require a pull request before merging to the main branch
* Require all commits be made to a non-target branch and submitted via a pull request before they can be merged.
* Required approvals - Must specify the number of approving reviews that are required before a pull request can be merged.

