# set_assume
## set_assume script
This script can get and set AssumeRole Credentials.  
required: jq command

usage: source set_assume.sh [option]  
Options:  
- -a: role-arn (required)  
- -n: role-session-name (required)  
- -s: serial-number  
- -t: token-code  

## unset_env_credentials script
Unset AWS credentials in environment variable.
usage: source unset_env_credentials