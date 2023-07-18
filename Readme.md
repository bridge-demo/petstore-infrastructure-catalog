# Petstore infrastructure Repository
This repository contains the cloud infrastructure required to deploy petstore application on azure.
Here is a breakdown of the important folders in this repo:

## 'azure' Folder: 
- Contains a folder 'Petstore-Infrastructure-and-Application-on-Azure': Has all Terraform infrastructure
- Contains 'icb_catalog_metadata.json': Has the configuration of the catalog item such as, specifying a provider, point to the folder of the cloud infrastructure  
**Note:** The name of the catalog item will be the name o the folder containing the cloud infrastrucute. To change it just rename the folder

## 'ready-to-import-zip-files' Folder
 - All zip files inside this folder are ready to be imported to a modernOps tenant
