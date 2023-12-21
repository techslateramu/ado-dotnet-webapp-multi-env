![TechSlate](img/ts.png)

# <span style="color: lightgreen;">**Executing an CI/CD Pipeline for running a Dotnet web Application in Multi Environments.**</span>


# <span style="color: lightpink;">Introduction

- **What is ``CI/CD Pipeline``** ?

    A continuous integration and continuous deployment (CI/CD) pipeline is a series of steps that must be performed in order to deliver a new version of software. CI/CD pipelines are a practice focused on improving software delivery throughout the software development life cycle via automation. 

    By automating CI/CD throughout development, testing, production, and monitoring phases of the software development lifecycle, organizations are able to develop higher quality code, faster and more securely. Although it’s possible to manually execute each of the steps of a CI/CD pipeline, the true value of CI/CD pipelines is realized through automation.

- **What are ``Group Variables``** ?

   Variable groups store values and secrets that you might want to be passed into a YAML pipeline or make available across multiple pipelines. You can share and use variable groups in multiple pipelines in the same project.

   Secret variables in Variables groups are protected resources. You can add combinations of approvals, checks, and pipeline permissions to limit access to secret variables in a variable group. Access to non-secret variables is not limited by approvals, checks, and pipeline permissions.
- **What are ``Approvers``** ?  
  
  You can manually control when a stage should run using approval and checks. This check is commonly used to control deployments to production environments.

- This project contains few terraform resources ( for ex: ``resource group``, ``key_vault``, ``app_service_plan``, ``linux_web_app``, ``application_insights``, ``analytics_workspace``, ``key_vault_secret`` )
- There is ADO pipeline written ( use Azure DevOps to run Pipeline)
- Make sure to follow pre-requisites to create stroage account and service principal

# <span style="color: lightpink;">Pre-requisites
 - **Create Service Prinicipal.**
 - **Add all the details to 'common' group varialbe in ADO.**
 - **Give contributor access to Service Principal.**
 - **Create a storage account, since we store terraform statefile into storage account.**
 - **Storage account details, store them into ``COMMON`` group variable.**

  ![Common](img/common.png)

 * ARM_CLIENT_ID
 * ARM_CLIENT_SECRET
 * ARM_TENANT_ID
 * ARM_SUBSCRIPTION_ID
 * az_sc_name
 * tf_state_rg_name
 * tf_state_st_acc_name
 * tf_state_st_cont_name
 * tf_state_subscription_id
 * tf_state_tenant_id

- **If you see above , we have added another varaible for ``Service Connection`` . i.e, ``az_sc_name``**
- **To create ``Service connection`` , we have to go back to Azure DevOps and Click on ``Project setting`` , and select ``Service Connections`` .**

![Common](img/sc.png)

- **Click on  ``New Service Connection`` .**

![Common](img/new-sc.png)

- **Select ``Azure Resource Manager`` .**

![Common](img/arm.png)

- **Select ``Service Principal (Manual)`` .**

![Common](img/sp.png)

- **Fill in the text boxes with the respective ``Subscription-Id`` , ``Client-Id`` , ``Tenant-Id`` and ``Client-Secret`` .**

![Common](img/sub.png)

- **Click on  ``Verify and Save`` .**

![Common](img/verify.png)

- **The ``Service-Connection`` got created Successfully . Add the same name under the Common variables as shown above.**

![Common](img/sc-name.png)

# <span style="color: lightpink;">Folder Structure
- Modules - which contains modules of terraform
- Pipeline - this folder contains pipeline
- Terraform - this folder contains actual terraform project files ( main.tf, var.tf, provider.tf, backend.tf)

# <span style="color: lightpink;">Pipeline
- Pipeline contains 4 steps, terraform init, validte, plan, apply 
- Make sure to set env variables ( including terraform backend variables) - pls see pre-requisites for more info.


# <span style="color: lightpink;">Process

### 1. **First step to begin with , Open your VS CODE and do ``clone`` the repository .**

 ![env](img/git-clone.png)

### 2. **Refer to the script properly and understand all the files , Compare the scripts between ``infra-pipeline-with-templates.yml`` and ``infra-pipeline-with-approvers.yml``.**

 ![env](img/repo.png) 

### 3. **Once you are done with understanding the scripts , Now come back to https://dev.azure.com/ (Azure DevOps) and Import your repository here.**

 ![env](img/repo-import.png)   

### 4. Repository imported successfully , now lets just check whether mentioned group variables in the pipeline are created in Azure DevOps Library or not .

![env](img/import.png)

### 5.a Let's go back to the ``Library`` and confirm the presence of group varaibles i.e, ``Common``, ``env-dev`` and ``env-prod``. Make sure that below , Resource Group , Storage Account and Container are created in portal and names as it is .

- ### <span style="color: gold;">**Common**

    <span style="color: gold;">tf_state_rg_name

    <span style="color: gold;">tf_state_st_acc_name

    <span style="color: gold;">tf_state_st_cont_name

![env](img/common.png)

- ### <span style="color: gold;">**env-dev**

![Calc](img/env-dev.png)

- ### <span style="color: gold;">**env-prod**

![Calc](img/env-prod.png)

### 5.b Along with Group variables , you need to add an environment with the name ``"Prod-Approvers"``

![Calc](img/env.png)

### 6. Now let's run the pipeline , Click on ``New Pipeline`` .

![Calc](img/pipeline.png)

### 7. Select  ``Azure Repos Gits`` .

![Calc](img/azure-git.png)

### 8. Select the Repository .

![Calc](img/select-repo.png)

### 9. Click on ``Existing Azure Pipelines YAML file`` .

![Calc](img/exist-pipe.png)

### 10. Select the Pipeline Path , and Click on ``Continue`` .

![Calc](img/path.png)

### 11.  Click on ``RUN`` .

![Calc](img/run.png)

### 12. The pipeline has started to Run , Lets wait for sometime .

![Calc](img/wait.png)

### 13. So, when the pipeline got initialised it will ask you to permit to access the Group Variables , you need to click on ``Permit`` for both the Group Variables .

![Calc](img/permit.png)

### 14. When it comes to ProdApply stage it will also ask you to permit to access Environment (Prod-Approvers).

![Calc](img/approvers.png)

### 15. The Infra Pipeline has run Sucessfully.

![Calc](img/pipe-succ.png)

### 16. Now moving further we need to to run the application pipeline (CI/CD), lets take the respective path of the pipeline and repeat the process , Click on ``New Pipeline``.

![Calc](img/pipeline.png)

### 17. Select  ``Azure Repos Gits``.

![Calc](img/Azure-git.png)

### 18. Select the Repository .

![Calc](img/select-repo.png)

### 19. Click on ``Existing Azure Pipelines YAML file`` .

![Calc](img/exist-pipe.png)

### 20. Select the appropriate path ``/ado-pipeline/app-pipeline.yaml`` and click on ``Continue``.

![Calc](img/cicd-path.png)

### 21. Click on ``Run``.

![Calc](img/cicd-run.png)

### 21. The pipeline has started to Run , Lets wait for sometime .

![Calc](img/cicd-wait.png)

### 22. So, when the pipeline got initialised it will ask you to permit to access the Group Variables , you need to click on ``Permit``.

![Calc](img/cicd-permit.png)

### 23. Pipeline is successfull and Deployment is done.

![Calc](img/pipe.png)

### 24. Let's refer back to the portal and see our resources got created.

![Calc](img/rg.png)

### 25. Let's get into dev resource group and try to access web app

![Calc](img/webapp.png)

### 26. Click on ``Default Domain``

![Calc](img/domain.png)

### 27..Net application running successfully.

![Calc](img/.net.png)
