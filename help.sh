#!/usr/bin/env

echo "$(cat << 'EOF'
Moulinette 2M

USE:
	Make sure to have a '.env' file with required and/or optional variables to make it works

VARIABLES:
	USERNAME: Username of your remote repository account
	HOST: host of your hub (for default is 'git@github.com:')
	REPO_URL: host layout, like https://$(HOST)/$(USERNAME)/$(REPO)

RULES:
	Rules are project tests.

	help - display moulinette help
	eu-aceito - tests 'Eu Aceito' projects
	trace - display all project trace logs
EOF
)"
