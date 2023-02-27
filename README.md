
## Dockerfiles
* `/mediawiki-app/Dockerfile` - For installing and configuring Mediawiki 
* `/mysqldb-wiki/Dockerfile`  - For installing and configuring MySql for handling Mediawiki database.

## Docker-compose
* `docker-compose.yml` file has been provided to setup the Mediawiki and Mysql services on a docker node.

## Kubernetes
The kubernetes objects are defined in following files inside k8s directory: `db-persistentvolumeclaim.yaml` `file-persistentvolumeclaim.yaml` `mediawiki-deployment.yaml` `mediawiki-service.yaml` `db-deployment.yaml` `db-service.yaml` `env-configmap.yaml` `wikinetwork-networkpolicy.yaml` `secret.yaml`

* `secret.yaml` file is created for storing base64 converted password string to be used for variable MYSQL_ROOT_PASSWORD.

Replace the encrypted string by generating a new string using command: `echo -n "<new_password>" | base64`

### Deploying the Stack
On the Kubernetes workstation, run command:

```bash
cd k8s
kubectl apply -f db-persistentvolumeclaim.yaml,file-persistentvolumeclaim.yaml,mediawiki-deployment.yaml,mediawiki-service.yaml,db-deployment.yaml,db-service.yaml,env-configmap.yaml,secret.yaml
```

Once both the Mediawiki and db pods are up and running, the app UI can be accessed using the Mediawiki service hostname/ip and port.

Configure the Mediawiki by providing the values as below:
* Database Host : `db:33060`
* Database Name : `wikidatabase`
* Database Username : `root`
* Database Password : `Passw0rd`

After the DB connections are setup, provide details for setting up your new Wiki.

After final submission you it will generate a LocalSettings.php file which needs to be copied on the mediawiki container at location: `/opt/rh/httpd24/root/var/www/html/mediawiki`. The Mediawiki deployment needs to be modified to change this directory location as a mount point from localhost or a S3 bucket.

# Helm Chart

Install the Helm chart using command: 

```bash
    cd terraform_script
    helm create mediawiki-chart-values
    rm -rf ./mediawiki-chart-values/*
    rsync -r mediawiki-chart-values/ mediawiki-chart
    helm install mediawiki-chart ./mediawiki-chart-values
```
# Terraform 

Inside terraform_script directory we are creating GKE resources using terraform.

    Inside resources.tf
    1) We are createing the GKE cluster
    2) We have created one custom script helmdeploy.sh. From that script we will connect to the GKE cluster and do the helm deploy.
    3) Using "null_resource" We'll call the helmdeploy.sh script.
    4) to delete everything in terraform destroy we have created one "null_resource" on_destroy and calling helm uninstall from it.

