# OpenShift Template for Odoo

## Description
This is a project to build templates for running Odoo app inside OpenShift pods using Kompose.

## Using this project
### When to use this project
If you are working with OpenShift and you want to run Odoo app, this project can be useful for you.

### When not using this project
If you aren't working with OpenShift and you just want to deploy Odoo in Docker over your host or a cloud environment, the [official Odoo template](https://hub.docker.com/_/odoo/) is more lightweight and suitable.

## Prerequisites
You need to install kompose in order to convert docker-compose and Dockerfile into yaml templates for using with OpenShift. You many need kubectl program if you want to apply the generated templates instead running directly into your OpenShift instance with kompose.

You can download kompose [here](https://github.com/kubernetes/kompose/blob/master/docs/installation.md)

## Deploy Odoo in OpenShift
You can do in two different ways:

### Deploying directly into OpenShift project
1. Just login into your cluster:<br/>
```oc login https://api.<starter_or_pro>-<location>.openshift.com --token=<token>```

2. Select a project:<br/>
```oc project <project_name>```

3. Start the conversion and deployment proccess <br/>
```kompose --file docker-compose.yml --provider openshift --verbose up```
<br/>
Image generation can take a big time, so please be patient.
<br/>
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
