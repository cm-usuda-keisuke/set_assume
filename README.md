# set_assume
## set_assume script
This script can get and set AssumeRole Credentials.
required: jq command

usage: source set_assume.sh [option]
Options:
  required options:
    arn option: ('-i and -r') or '-a'
      e.g. -a = arn:aws:iam::-i:role/-r 
    name option: '-n'
- -i: account id in arn
- -r: assume role name in arn
- -a: role-arn
- -n: role-session-name
- -s: serial-number
- -t: token-code

If you want to omit role name, please set $AWS_SETSTS_DEFAULT_ROLE
e.g. $ echo "export AWS_SETSTS_DEFAULT_ROLE=your_role_name" >> ~/.bash_profile

## unset_env_credentials script
Unset AWS credentials in environment variable.  
usage: source unset_env_credentials.sh