# Terraform code to deploy three-tier architecture on azure

## What is three-tier architecture?
Three-tier architecture is a well-established software application architecture that organizes applications into three logical and physical computing tiers: the presentation tier, or user interface; the application tier, where data is processed; and the data tier, where the data associated with the application is stored and managed.

## Installation
- [Terraform](https://www.terraform.io/downloads.html)


## Deployment

### Steps

**Step 0** `terraform init`

used to initialize a working directory containing Terraform configuration files

**Step 1** `terraform plan`

used to create an execution plan

**Step 3** `terraform apply`

used to apply the changes required to reach the desired state of the configuration

## Creating a multi-container app.


# Configuring the environment 

**1** Start PowerShell or Command Prompt. 

**2** Log in the Azure portal by entering the command ‘az login’ & then entering the credentials. After getting access to the azure subscription check & install terraform. 

**3** In Azure Portal Cloud Shell, create a new directory and then change to it. Clone the sample app repository by  

`git clone https://github.com/SaumyaG29/multicontainerwordpress`  to the new directory and then change to “multicontainerwordpress” directory. 


 
## Creating an App Service plan on Azure 

  In command prompt apply the following command to create an App Service Plan in the provisioned resource group. 
 
     `az appservice plan create --name myAppServicePlan --resource-group myResourceGroup --sku S1 --is-linux`
 
 
 ## Docker Compose app 

 In the azure portal, open Cloud Shell, and create a multi container web-app. 

    `az webapp create --resource-group myResourceGroup --plan myAppServicePlan --name <app-name> --multicontainer-config-type compose --multicontainer-config-file docker-compose-wordpress.yml`
 

## Running the created app. 
  Run the deployed app using the default host name created in the above step. 
  
## Configuring a Server firewall 

    `az mysql server firewall-rule create --name allAzureIPs --server <mysql-server-name> --resource-group myResourceGroup --start-ip-address 0.0.0.0 --end-ip-address 0.0.0.0`

## Creating and Deploying the WordPress Database 
   
    `az mysql db create --resource-group myResourceGroup --server-name <mysql-server-name> --name wordpress`
 

## Configuring the database variables in WordPress 

    `az webapp config appsettings set --resource-group myResourceGroup --name <app-name> --settings WORDPRESS_DB_HOST="<mysql-server-name>.mysql.database.azure.com" WORDPRESS_DB_USER="adminuser@<mysql-server-name>" WORDPRESS_DB_PASSWORD="My5up3rStr0ngPaSw0rd!" WORDPRESS_DB_NAME="wordpress" MYSQL_SSL_CA="BaltimoreCyberTrustroot.crt.pem"`

 

## Updating the created app with new configurations 
```YAML
    version: '3.3'

services:
   wordpress:
     image: mcr.microsoft.com/azuredocs/multicontainerwordpress
     ports:
       - "8000:80"
     restart: always
```
`az webapp config container set --resource-group myResourceGroup --name <app-name> --multicontainer-config-type compose --multicontainer-config-file docker-compose-wordpress.yml`

## Adding persistent storage 

After a restart, if persistent storage is not added, the current WordPress installation would be gone. 

`az webapp config appsettings set --resource-group myResourceGroup --name <app-name> --settings WEBSITES_ENABLE_APP_SERVICE_STORAGE=TRUE`


## Updating the app with new configuration 

 ```YAML
 version: '3.3'

services:
   wordpress:
     image: mcr.microsoft.com/azuredocs/multicontainerwordpress
     volumes:
      - ${WEBAPP_STORAGE_HOME}/site/wwwroot:/var/www/html
     ports:
       - "8000:80"
     restart: always
 ```
 `az webapp config container set --resource-group myResourceGroup --name <app-name> --multicontainer-config-type compose --multicontainer-config-file docker-compose-wordpress.yml`
 
 
## Adding Redis container 
```YAML
version: '3.3'

services:
   wordpress:
     image: mcr.microsoft.com/azuredocs/multicontainerwordpress
     ports:
       - "8000:80"
     restart: always

   redis:
     image: mcr.microsoft.com/oss/bitnami/redis:6.0.8
     environment: 
      - ALLOW_EMPTY_PASSWORD=yes
     restart: always
```

### Configuring the environment variables 
`az webapp config appsettings set --resource-group myResourceGroup --name <app-name> --settings WP_REDIS_HOST="redis"`

 ### Updating the app with new configuration 

 `az webapp config container set --resource-group myResourceGroup --name <app-name> --multicontainer-config-type compose --multicontainer-config-file compose-wordpress.yml`


### Running the created App. 

Complete all the steps and install WordPres at `[http://<app-name>.azurewebsites.net]`
  
  
### Connecting WordPress to Redis 

**1** Sign in to WordPress admin. In the left navigation, select Plugins, and then select Installed Plugins.
**2** In the Plug-ins section activate the Redis Object Cache.
**3** After selecting Settings, click on Enable Object Cache. 
**4** As the WordPress gets connected to the Redis server, the connection status immediately appears on that page.

## Clean up the deployment
`terraform destroy` or `az group delete --name myResourceGroup`
