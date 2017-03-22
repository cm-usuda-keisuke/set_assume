# set_assume
## set_assume script
This script can get and set AssumeRole Credentials.  
required: jq command

usage: source set_assume.sh [option]  
Options:  
'-i and -r' or '-a' is required  
e.g. -a = arn:aws:iam::-i:role/-r
- -i: account id in arn
- -r: assume role name in arn
- -a: role-arn
- -n: role-session-name (required)
- -s: serial-number
- -t: token-code

## unset_env_credentials script
Unset AWS credentials in environment variable.  
usage: source unset_env_credentials.sh