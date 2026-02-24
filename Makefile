.DEFAULT_GOAL := help

include .env
export

NAME = eu-aceito shell-00 shell-01

HOST ?= git@github.com:

REPO_URL ?= $(HOST)$(USERNAME)/$(REPO).git


init:
	@bash init.sh


help:
	@bash help.sh


all: init $(NAME)


trace:
	@bash trace.sh


$(NAME): REPO=$@


$(NAME): init
	@cd $@ && ./test.sh "$(REPO_URL)" "$(REPO)" && cd ..
	@rm -rf "/tmp/$(REPO)"


.PHONY: init help $(NAME)
