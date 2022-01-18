# Docker - Apache Cordova

This is a containerized version with the minimum install requirements for Apache Cordova 

To make it easier and clean to install Apache Cordova with less storage space usage possible using only terminal command line environment.

This bash script will automatically install:

* Android-SDK platform-19 built-tools-29.0.1
* Gradle 4.10.3 + GooglePlayServices
* Java JDK8 Headless
* Apache Cordova
* NodeJS
* NPM

Tested with **Ubuntu 16.04**, **MacOS Mountain Lion ^** and **Windows 10**. 

*Pretty much every OS that runs docker*

# How it works

Just clone this repository for every new App project you might wanna start and then start the 
`cordova.bat`