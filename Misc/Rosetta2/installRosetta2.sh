#!/bin/bash
#set -x

############################################################################################
##
## Script to check if we need Rosetta 2 and install if required
##
###########################################

## Copyright (c) 2020 Microsoft Corp. All rights reserved.
## Scripts are not supported under any Microsoft standard support program or service. The scripts are provided AS IS without warranty of any kind.
## Microsoft disclaims all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a
## particular purpose. The entire risk arising out of the use or performance of the scripts and documentation remains with you. In no event shall
## Microsoft, its authors, or anyone else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever
## (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary
## loss) arising out of the use of or inability to use the sample scripts or documentation, even if Microsoft has been advised of the possibility
## of such damages.
##
##
## Credit: Initial idea and example commands taken from https://derflounder.wordpress.com/2020/11/17/installing-rosetta-2-on-apple-silicon-macs/
##
## Feedback: neiljohn@microsoft.com

# Define variables

appname="Rosetta2"
logandmetadir="/Library/Intune/Scripts/$appname"
log="$logandmetadir/$appname.log"

## Check if the log directory has been created
if [ -d $logandmetadir ]; then
    ## Already created
    echo "$(date) | Log directory already exists - $logandmetadir"
else
    ## Creating Metadirectory
    echo "$(date) | creating log directory - $logandmetadir"
    mkdir -p $logandmetadir
fi

# start logging

exec 1>> $log 2>&1

# Begin Script Body

echo ""
echo "##############################################################"
echo "# $(date) | Starting install of $appname"
echo "############################################################"
echo ""

# Let's check to see if we need Rosetta 2
processor=$(/usr/sbin/sysctl -n machdep.cpu.brand_string | grep -o "Intel")
if [[ -n "$processor" ]]; then
    echo "$(date) | $processor processor installed. No need to install Rosetta."
else

    # OK, we need Rosetta but is it already installed?
    # Let's look for the LaunchDaemon...
    
    if [[ ! -f "/Library/Apple/System/Library/LaunchDaemons/com.apple.oahd.plist" ]]; then

        echo "$(date) | Rosettate2 not installed, starting install process"
        /usr/sbin/softwareupdate --install-rosetta --agree-to-license
        if [[ $? -eq 0 ]]; then
        	echo "$(date) | Rosetta2 has been successfully installed."
        else
        	echo "$(date) | Rosetta2 installation failed!"
        	exit 1
        fi
   
    else
    	echo "$(date) | Rosetta2 is already installed. Nothing to do."
    fi
fi