# set_assume
## set_assume script
This script can get and set AssumeRole Credentials.  
Required: jq command  

Usage: `source set_assume.sh [options]`  
Options:  
- -i: account id in arn
- -r: assume role name in arn
- -a: role-arn
- -n: role-session-name
- -s: serial-number
- -t: token-code

Required options:  
- arn option: ('-i and -r') or '-a'  
    - e.g. -a = arn:aws:iam::-i:role/-r  
- name option: '-n'  

If you want to omit role name, please set `$AWS_SETSTS_DEFAULT_ROLE`  
e.g. `$ echo "export AWS_SETSTS_DEFAULT_ROLE=your_role_name" >> ~/.bash_profile`  

If you want to omit mfa serial number, please set `$AWS_SETSTS_DEFAULT_SERIAL`  
e.g. `$ echo "export AWS_SETSTS_DEFAULT_SERIAL=your_serial_number" >> ~/.bash_profile`  

## unset_env_credentials script
Unset AWS credentials in environment variable.  
Usage: `source unset_env_credentials.sh`  