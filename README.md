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

If you want the bash prompt to display the session name, please set the following to .bashrc:  
```
PS1="\h:\W \u\`
if [ ! -z \"\$AWS_SETSTS_ROLE_SESSION_NAME\" ]; then
    echo \" [\$AWS_SETSTS_ROLE_SESSION_NAME] \";
fi
\`\$ "
```
It looks like `host:working_dir user [session] $ `  
I think it is even better if you set the color at prompt or iTerm2.

## unset_env_credentials script
Unset AWS credentials in environment variable.  
Usage: `source unset_env_credentials.sh`  