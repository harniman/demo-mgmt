# Docker image for Demo Mgmt server

FROM debian:jessie
MAINTAINER Nigel Harniman <nharniman@cloudbees.com>

RUN apt-get update && apt-get install -y --no-install-recommends \
	curl \
	telnet \ 
	tcpdump \
	git-core \
	vim
