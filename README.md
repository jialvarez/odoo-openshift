# Running Odoo in Openshift

## Description
This is a project to build templates for running Odoo app inside OpenShift pods using Kompose.

## Using this project
### When to use this project
If you are working with OpenShift and you want to run Odoo app, this project can be useful for you.

### When not using this project
If you aren't working with OpenShift and you just want to deploy Odoo in Docker over your host or a cloud environment, the [official Odoo template](https://hub.docker.com/_/odoo/) is more lightweight and suitable.

## Prerequisites
You need to install kompose in order to convert docker-compose and Dockerfile into yaml templates for using with OpenShift. You many need kubectl program if you want to apply the generated templates instead running directly into your OpenShift instance with kompose.

You can download kompose [here](https://github.com/kubernetes/kompose/blob/master/docs/installation.md).

## Deploy Odoo in OpenShift
First of all, you need to download this project and the submodule inside pointing the official odoo repository.<br/>
```git clone https://github.com/jialvarez/odoo_openshift.git && cd odoo_openshift```<br/>
```git submodule update --init --remote```

Then, you can deploy it in two different ways:

### Deploying directly into OpenShift project
1. Just login into your cluster:<br/>
```oc login https://api.<starter_or_pro>-<location>.openshift.com --token=<token>```

2. Select a project:<br/>
```oc project <project_name>```

3. Start the conversion and deployment proccess <br/>
```kompose --file docker-compose.yml --provider openshift --verbose up```<br/><br/>
Image generation can take a big time, so please be patient.
<br/><br/>
If you want to remove pods, deployments, and volumes generated, you should type:<br/>
```kompose --file docker-compose.yml --provider openshift --verbose down```

### Generating templates and then deploy into OpenShift project

1. Just login into your cluster:<br/>
```oc login https://api.<starter_or_pro>-<location>.openshift.com --token=<token>```

2. Select a project:<br/>
```oc project <project_name>```

3. Generate templates<br/>
```mkdir templates && kompose --provider openshift -v convert -f docker-compose.yml -o templates/```

4. Apply them<br/>
```kubectl apply -f templates/```

## Deploy Odoo in Docker containers
You should use the [official Odoo template](https://hub.docker.com/_/odoo/) for this, but anyway you can use this image both to deploy in cloud or in OpenShift. I use the same image to deploy to Google Cloud and to OpenShift.<br/><br/>
You need to [uncomment line defining the volume for Docker container](https://github.com/jialvarez/odoo_openshift/blob/master/docker-compose.yml#L22) and [comment the OpenShift one](https://github.com/jialvarez/odoo_openshift/blob/master/docker-compose.yml#L19).<br/><br/>
And then just type:<br/>
```docker-compose up -d```

## Screenshots
![alt text](https://github.com/jialvarez/odoo_openshift/raw/master/screenshots/001.png "Deployments")
![alt text](https://github.com/jialvarez/odoo_openshift/raw/master/screenshots/002.png "Pods")
![alt text](https://github.com/jialvarez/odoo_openshift/raw/master/screenshots/003.png "Odoo")
