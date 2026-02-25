#!/usr/bin/env

echo "$(cat << 'EOF'
Moulinette 2M

USE:
	Make sure to have a '.env' file with required and/or optional variables to make it works

VARIABLES:
	USERNAME: Username of your remote repository account (REQUIRED)
	HOST: host of your hub (for default is 'git@github.com:') (OPTIONAL)
	REPO_URL: host layout, like https://$(HOST)/$(USERNAME)/$(REPO) $(OPTIONAL)

RULES:
	Rules are project tests.

	help - display moulinette help
	eu-aceito - tests 'Eu Aceito' projects
	shell-00 - tests 'Shell 00' projects
	trace - display all project trace logs
EOF
)"
