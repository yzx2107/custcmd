# custcmd
customize the cp/mv as cust_cp/cust_mv shell command to support run with test/do mode and printing the diff info.

## usage
### run as a single line command 
1. to run with test mode: . custcmd.sh test && [cust_cp|cust_mv] file_from file_to
2. to run with do mode: . custcmd.sh do && [cust_cp|cust_mv] file_from file_to
### reference as a shell library
1. loaded the custcmd.sh as . custcmd.sh from your script
2. then can use those commands cust_cp/cust_mv from your script

## mode
* test - just did a checking, not execute the cp/mv commands
* run - execute the cp/mv commands
