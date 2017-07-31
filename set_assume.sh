#!/bin/bash
# set assume role script
# version 1.2

# define help
help() {
	echo 'This script can get and set AssumeRole Credentials.'
	echo 'usage: source set_assume.sh [option]'
	echo 'Options:'
	echo "# required options:"
	echo "#   arn option: ('-i and -r') or '-a'"
	echo '#     e.g. -a = arn:aws:iam::-i:role/-r'
	echo "#   name option: '-n'"
	echo '-i: account id in arn'
	echo '-r: assume role name in arn'
	echo '-a: role-arn'
	echo '-n: role-session-name'
	echo '-s: serial-number'
	echo '-t: token-code'
	echo ''
	echo 'If you want to omit role name, please set $AWS_SETSTS_DEFAULT_ROLE'
	echo 'e.g. $ echo "export AWS_SETSTS_DEFAULT_ROLE=your_role_name" >> ~/.bash_profile'
}

# unset old profile args
unset AWS_SETSTS_ACCOUNT_ID
unset AWS_SETSTS_ROLE
unset AWS_SETSTS_ROLE_ARN
unset AWS_SETSTS_ROLE_SESSION_NAME
unset AWS_SETSTS_SERIAL_NUMBER
unset AWS_SETSTS_TOKEN_CODE

# loop because exit by break in source command
while : ;do
	# check args
	if [ $# -eq 0 ]; then
		echo 'argments is required'
		help
		break
	fi

	# if default role is set, use it
	AWS_SETSTS_ROLE=$AWS_SETSTS_DEFAULT_ROLE

	# get args
	OPTIND=1
	while getopts "i:r:a:n:s:t:h" opt; do
		case "$opt" in
			h) help
				break 2
				;;
			i) AWS_SETSTS_ACCOUNT_ID=$OPTARG
				;;
			r) AWS_SETSTS_ROLE=$OPTARG
				;;
			a) AWS_SETSTS_ROLE_ARN=$OPTARG
				;;
			n) AWS_SETSTS_ROLE_SESSION_NAME=$OPTARG
				;;
			s) AWS_SETSTS_SERIAL_NUMBER=$OPTARG
				;;
			t) AWS_SETSTS_TOKEN_CODE=$OPTARG
				;;
			\?) help
				break 2
				;;
		esac
	done

	# check params
	if [ -n "$AWS_SETSTS_ACCOUNT_ID" -a ${#AWS_SETSTS_ACCOUNT_ID} -eq 14 ]; then
		AWS_SETSTS_ACCOUNT_ID=$(echo $AWS_SETSTS_ACCOUNT_ID | sed -e 's/-//g')
	fi

	if [ ! -n "$AWS_SETSTS_ROLE_ARN" ]; then
		if [ -n "$AWS_SETSTS_ACCOUNT_ID" -a -n "$AWS_SETSTS_ROLE" ]; then
			AWS_SETSTS_ROLE_ARN="arn:aws:iam::${AWS_SETSTS_ACCOUNT_ID}:role/${AWS_SETSTS_ROLE}"
		else
			echo "('-i and -r') or '-a' is required"
			break
		fi
	fi

	if [ ! -n "$AWS_SETSTS_ROLE_SESSION_NAME" ]; then
		echo "'-n: role-session-name' is required"
		break
	fi

	# check to use MFA
	if [ -n "$AWS_SETSTS_SERIAL_NUMBER" -a -n "$AWS_SETSTS_TOKEN_CODE" ]; then
		# use MFA
		echo 'role-arn:' $AWS_SETSTS_ROLE_ARN
		echo 'role-session-name:' $AWS_SETSTS_ROLE_SESSION_NAME
		echo 'serial-number:' $AWS_SETSTS_SERIAL_NUMBER
		echo 'token-code:' $AWS_SETSTS_TOKEN_CODE
		result="$(aws sts assume-role \
			--role-arn "$AWS_SETSTS_ROLE_ARN" \
			--role-session-name "$AWS_SETSTS_ROLE_SESSION_NAME" \
			--serial-number "$AWS_SETSTS_SERIAL_NUMBER" \
			--token-code "$AWS_SETSTS_TOKEN_CODE" 2>&1)"
	else
		# don't use MFA
		echo $AWS_SETSTS_ROLE_ARN
		echo $AWS_SETSTS_ROLE_SESSION_NAME
		result="$(aws sts assume-role \
			--role-arn "$AWS_SETSTS_ROLE_ARN" \
			--role-session-name "$AWS_SETSTS_ROLE_SESSION_NAME" 2>&1)"
	fi

	# result check
	echo $result
	echo $result | jq . > /dev/null 2>&1 || break
	# export env
	export AWS_ACCESS_KEY_ID="$(echo "$result" \
		| jq -r '.Credentials.AccessKeyId')"
	export AWS_SECRET_ACCESS_KEY="$(echo "$result" \
		| jq -r '.Credentials.SecretAccessKey')"
	export AWS_SESSION_TOKEN="$(echo "$result" \
			| jq -r '.Credentials.SessionToken')"
	echo 'export success'
	echo 'AWS_ACCESS_KEY_ID:' $AWS_ACCESS_KEY_ID
	echo 'AWS_SECRET_ACCESS_KEY:' $AWS_SECRET_ACCESS_KEY
	echo 'AWS_SESSION_TOKEN:' $AWS_SESSION_TOKEN
	# check status
	aws sts get-caller-identity
	aws configure list
	break
done
