github-service-ruby
===================

A Service Broker is required to integrate any service as a [Managed Service](http://docs.cloudfoundry.com/docs/running/architecture/services/#managed) on Cloud Foundry.

This sample Service Broker is written in ruby, and can be used as a basis for writing broker for any other services.

This example is a standalone ruby application (based on Sinatra) that implements the [v2.0 Service Broker API (also known as the Services API)](http://docs.cloudfoundry.com/docs/running/architecture/services/writing-service.html).

Generally, a Service Broker can either be a standalone application that communicates with a service that it administers, or a Service Broker can be implemented as a component of a service. I.e. if the service itself is a Ruby on Rails application, the code in this repository can be added into the application (either copied in, or added as a Rails engine).


## The GitHub repo service

In this example, the service provided is the management of repositories inside a single GitHub account owned by the service administrator.

The Service Broker provides 5 basic functions:

Function | Resulting action |
-------- | :--------------- |
catalog | advertises the GitHub repo services and the plans offered.
create | creates a ([TODO]public/private) repository inside the account. This repository can be thought of as a service instance.
bind | generates a GitHub deploy key which gives write access to the repository, and makes the key and repository URL available to the application bound to the service instance.
unbind | destroys the deploy key bound to the service instance.
delete | deletes the service instance (repository).

The GitHub credentials of the GitHub account adminstrator are hardcoded and should be changed if you are deploying your own instance of this broker application.  We suggest that you create a dedicated GitHub account solely for the purpose of testing this broker (since it will create and destroy repositories).




## Deployment

This application can be deployed on any environment or hosting service.

For example, to deploy this broker application to Cloud Foundry

1. install the `cf` or `gcf` command line tool
2. log in as a cloud controller admin using `cf login` or `gcf login`
3. clone this git repository
4. [TODO] add the GitHub credentials for the account in which you want this service broker to provide respository services
5. [TODO] configure Basic Auth credentials
6. `cd` into the application root directory
7. run `cf push` to deploy the application to Cloud Foundry



## Adding your Service Broker

In order for Cloud Foundry to make a service available to applications deployed on it, the service broker must be added to Cloud Foundry.


Adding a service to Cloud Foundry involves two steps:

1. Register the service broker with Cloud Foundry
2. Make the service plans advertised by the broker public in Cloud Foundry marketplace

### Registering the Service Broker

The `cf add-service-broker` command is used to register the broker. The meaning of each field is described below:

Field | Value |
-------- | :--------------- |
Name | ????
URL | the URL at which the service broker is running
Username | Basic Auth username needed for Cloud Foundry to access the endpoints on the service broker
Password | Basic Auth password


```
> cf add-service-broker
Name> github-repo-broker

URL> http://github-repo-service-broker.10.244.0.34.xip.io

Username> admin

Password> password

Adding service broker github-repo-broker... OK
```

To verify that the broker has been added successfully:

```
> cf services --marketplace
Getting services... OK

service                     version   provider   plans   description
GitHub repository service   n/a       n/a        free    An instance of this service provides a repository which an app write to and read from
```

### Making the Service Plans Public

Please refer to the "Making a Plan Public" section of [Writing a Cloud Foundry Service Broker](http://docs.cloudfoundry.com/docs/running/architecture/services/writing-service.html) on instructions for how to make plans public.



## Misc
The Cloud Foundry commands used in this document were verified using the following CLI tool versions:

```
cf 5.4.3
```

```
gcf version 6.0.0.rc1-d04428f293
```
