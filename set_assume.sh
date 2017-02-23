#!/bin/sh

# define help
help() {
	echo 'This script can get and set AssumeRole Credentials.'
	echo 'usage: source set_assume [option]'
	echo 'Options:'
	echo '-a: role-arn (required)'
	echo '-n: role-session-name (required)'
	echo '-s: serial-number'
	echo '-t: token-code'
}

# unset old profile args
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

	# get args
	OPTIND=1
	while getopts "a:n:s:t:h" opt; do
		case "$opt" in
			h) help
				break 2
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
	if [ ! -n "$AWS_SETSTS_ROLE_ARN" ]; then
		echo "'-a: role-arn' is required"
		break
	fi

	if [ ! -n "$AWS_SETSTS_ROLE_SESSION_NAME" ]; then
		echo "'-n: role-session-name' is required"
		break
	fi

	# check to use MFA
	if [ -n "$AWS_SETSTS_SERIAL_NUMBER" -a -n "$AWS_SETSTS_TOKEN_CODE" ]; then
		# use MFA
		echo $AWS_SETSTS_ROLE_ARN
		echo $AWS_SETSTS_ROLE_SESSION_NAME
		echo $AWS_SETSTS_SERIAL_NUMBER
		echo $AWS_SETSTS_TOKEN_CODE
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
	break
done
