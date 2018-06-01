#!/bin/bash
# ---------------------------------------------------------------------------------------------------------------------------
# Name: RRPG - RandomRootPasswordGenerator
# Author: Joshua McDill
# Last Edit: 05.29.2018
# Description:
# This script creates and applies random root passwords over SSH, then dumps them to a CSV file that can be uploaded to
# LastPass password vault. Syntax below:
#
# ./rrpg4lp.sh <servername>
#
# NOTE: LastPass does not currently support importing CSV files to SHARED folders. Import to un-shared, then share as needed.
# Import URL for LastPass is https://lastpass.com/import.php
# ---------------------------------------------------------------------------------------------------------------------------
#
# Define variables (CSV file, user name, port)
#
        LPCSV=<some-log-file.csv>;
        USERN=<username>;
        SSHPORT=<ssh port>;
        TSERVER=$1;
        LASTPASS_DIR="<unshared/LastPass/directory>";
#
# use openssl to create a random password. Cutting out special chars for now
#
        RTPASSW=$(openssl rand -base64 12 | tr -dc [:alnum:]);
#
# execute password change over SSH...expect password prompt if you aren't using keys
#
        ssh -o loglevel=error -p $SSHPORT -t $USERN@$TSERVER "echo -e \"$RTPASSW\n$RTPASSW\" | sudo passwd root";
#
# Prime CSV file for logging (if you are running against a number of servers, paste this in the file manually.
#
#        echo "url,type,username,password,hostname,extra,name,grouping" >> $LPCSV;
#
# Log password and applicable server name to CSV file
#
        echo "$TSERVER,server,root,$RTPASSW,$TSERVER,Linux system,$TSERVER,$LASTPASS_DIR" >> $LPCSV;
#
# null out vars...
#
        LPCSV="";
        USERN="";
        SSHPORT="";
        TSERVER="";
        LASTPASS_DIR="";
