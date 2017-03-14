# About Airport Sample
Airport Sample is an application provided to introduce caching functionality of WebSphere eXtreme Scale image on IBM Bluemix Container Services (ICS). It runs create, read, update, and delete (CRUD) functions on a WebSphere eXtreme Scale cache in milliseconds. The sample shows how large amounts of data (in this case, information about thousands of airports worldwide) can be stored using a Simple or Session eXtreme Scale cache. 

# Requirements 
- Websphere eXtreme Scale (ibm-websphere-extreme-scale) image on IBM Bluemix Container Services will be used for the purpose of this tutorial
    - For documentation on setting up ibm-websphere-extreme-scale image for Bluemix, visit:  https://console.ng.bluemix.net/docs/images/docker_image_extreme_scale/ibm-websphere-extreme-scale_starter.html
    - Create a Simple or Session Grid in XSLD 

- Apache Maven software project management and comprehension tool
   - Download link: https://maven.apache.org/download.cgi
   - Installation Instructions: https://maven.apache.org/install.html

- JDK (Version as per system requirements specified by Maven)

- Git 
    - Download Link: https://git-scm.com/downloads
    
# Getting The Code 
To get the code, you can just clone the repository

```
git clone https://github.com/ibmWebsphereExtremeScale/AirportSample.git
```
For more information on cloning a remote repository, visit: https://help.github.com/articles/cloning-a-repository/

# Dependencies
The sample application uses three dependencies: A JSON library, javax.servlet API and ogclient.jar

- The JSON library and javax.servlet API are specified as dependencies in the POM.xml file. Maven will download the library from a public Maven repository and package it into the final artifact
- The ogclient.jar is NOT available in a public Maven repository. Download ogclient.jar from:
    ``` 
 https://hub.jazz.net/project/abchow/CachingSamples/abchow%2520%257C%2520CachingSamples/_2fYdgJMyEeO3qtc4gZ02Xw/_2fl44JMyEeO3qtc4gZ02Xw/downloads#https://hub.jazz.net/project/abchow/CachingSamples/abchow%2520%257C%2520CachingSamples/_2fYdgJMyEeO3qtc4gZ02Xw/_2fl44JMyEeO3qtc4gZ02Xw/downloads 
    ``` 
    Add it to your local repository by running the following maven command:

    ```
    $ mvn install:install-file -Dfile=<path-to-ogclient.jar> \
        -DgroupId=com.ogclient -DartifactId=ogclient \
        -Dversion=1.0 -Dpackaging=jar

    //Replace <path-to-orgclient.jar> with valid path to ogclient.jar
    ```  

# Building The Application 
After cloning the project and adding the ogclient.jar file to your local Maven repository, go to the directory where the POM.xml file is located and run this command to build the WAR file:

```
mvn clean install
```
Access the WAR file from the 'target' folder

# Bluemix Setup 
To run your application on Bluemix, you must sign up for Bluemix and install the Cloud Foundry command line tool. To sign up for Bluemix, head to https://console.ng.bluemix.net and register.

Download the Cloud Foundry command line tool by following the steps in https://github.com/cloudfoundry/cli

After you have installed Cloud Foundry command line tool, you need to point to Bluemix by running
```
cf login -a https://api.ng.bluemix.net
```
This will prompt you to login with your Bluemix ID and password.

# Providing Credentials
This application uses Bluemix user-provided service instance to provide credentials when connecting to Websphere eXtreme Scale. For more information visit https://console.ng.bluemix.net/docs/services/reqnsi.html#add_service

Create a json file that follows this format. Replace with valid credentials, making sure that you specify all catalog end points(public IPs bound to your WebSphere eXtreme Scale containers), seperated by a comma: 

```
  {"catalogEndPoint":"<catalog server endpoint:port, eg: 129.11.111.111:4809,129.22.222.222:4809>",
   "gridName":"<Simple or session grid name>",
   "username":"<username for WXS>",
   "password":"<password for WXS>"}
   
//Save the file as credentials.json
```
To create a user-provided service on Bluemix with your json file, run this command: 

```
cf cups <service-name> -p <path to/credentials.json file>

//Replace <service-name> with a name of your choosing BUT service name must have 'XSSimple' (for a simple cache) 
or 'XSSession' (for a session cache) as the prefix. For example:XSSimple-credentials or XSSession-credentials***
```
# Running The Application (UNDER CONSTRUCTION) 
 Once you have successfully logged in, push the WAR file to your Bluemix account with a Java Buildpack:

```
cf push <app name> -p AirportSampleApp.war -b https://github.com/cloudfoundry/java-buildpack

// If you get an error message about hostname being taken, this means that the app name was taken by someone else
Try this step again with a new app name
``` 

Next, bind the application to the user-provided service created 

```
cf bind-service <app name> <service name>
``` 

To allow communication between your application and the Websphere eXtreme Scale (WXS) containers on ICS, set the Bluemix HOSTSALIAS environment variables

```
cf set-env <app name> HOSTSALIAS_wxs1 111.11.111.11
cf set-env <app name> HOSTSALIAS_wxs2 222.22.222.22

//Replace wxs1 and wxs2 with the alias names you call when you start up WXS containers 
(the prefix should remain HOSTSALIAS_)
//the IPs are the public assigned IPs for your WXS containers. 
``` 

Restage the application so the changes will take effect 

```
cf restage <app name>
```
# Accessing The Application 
Logon to ACE console: https://console.ng.bluemix.net and find your application on the dashboard.Clicking on the link provided will launch your sample application.

# Troubleshooting
These are some suggestions on how you can troubleshoot the problem is the application is not running properly or an operation on the WebSphere eXtreme Scale failed. Check the application logs - from the Bluemix UI console, click on your application and select 'Logs'. Check for any error messages in the logs.

If there is a connection exception such as: 
- Go to the Bluemix console, click on your application. Select 'Runtime', then select the 'Environment variables' tab. Under VCAP services, ensure that the correct information is passed in for credentials (catalogEndPoint, gridName, password, username). Check that the Bluemix HOSTSALIAS environment variables are set correctly. 
- Check that the name of the user provided service contains the prefix XSSimple or XSSession (depending on the Grid type) 
- Ensure that the grid created is of type 'Simple' or 'Session'

If there is a security exception such as: 
```
APP/0    Failed to connect to grid
APP/0    [err] javax.cache.CacheException: com.ibm.websphere.objectgrid.ConnectException: CWOBJ1325E: There was a Client security configuration error. The catalog server at endpoint 129.41.233.108:4,809 is configured with SSL. However, the Client does not have SSL configured. The Client SSL configuration is null.
```
- This error indicates that the client application was not configured with SSL but WebSphere eXtreme Scale was configured with SSL

# License 
See LICENSE for license information
