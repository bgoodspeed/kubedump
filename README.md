# kubedump
Dump all configuration settings from a kubernetes cluster

# TL;DR
`./kubedump.sh kubeconfig.yaml dir_to_dump json`

# Install
Download `kubedump.sh`

Make executable `chmod +x kubedump.sh`


# Usage
Arguments:
1. kubeconfig.yaml - the kubeconfig file with credentials to access the cluster
2. directory -  to dump the configuration items into
3. json or yaml - the format to dump, files will be named with that extension, e.g. RESOURCE.json
4. true/false - also describe the resources, the files will be named describe_RESOURCE.txt 
