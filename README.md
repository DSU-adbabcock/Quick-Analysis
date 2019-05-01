# Lab13

## quickanalysis.ps1

This program provides a quick sort of "hub" to start doing malware analysis. A form will open providing a quick selection of a packet capture/binary, and checkboxes with tools to use on them. It will also provide hashes for binaries as well as a quick was to do a google search on all of them. Additionally, a button to open Process Explorer exists. 

### Parameters

-Config [string] (Default: .\config.xml)

Specifies the path to the xml config file. Default is config.xml within the working directory.

## Config File

The config.xml file simply contains paths to all of the desired programs. Full paths must be supplied if you want the program to run. An example config file and a skeleton is provided.