#
# email
# https://hub.docker.com/r/mailserver/docker-mailserver
#
NAME = mailserver
REPO = docker.io/mailserver/docker-mailserver:latest
#
ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
 
# Create the container
build:
        docker create \
                --name=$(NAME) \
                --hostname mail \
                --domainname lowtek.ca \
                -p 25:25 \
                -p 143:143 \
                -p 465:465 \
                -p 587:587 \
                -p 993:993 \
                -v /path/to/mail/maildata:/var/mail \
                -v /path/to/mail/mailstate:/var/mail-state \
                -v /path/to/mail/maillogs:/var/log/mail \
                -v /etc/localtime:/etc/localtime:ro \
                -v $(ROOT_DIR)/config/:/tmp/docker-mailserver/ \
                -v /path/to/etc/letsencrypt:/etc/letsencrypt \
                --env-file $(ROOT_DIR)/mailserver.env \
                --cap-add NET_ADMIN \
                --cap-add SYS_PTRACE \
                --restart=unless-stopped \
                $(REPO) 
 
# Start the container
start:
        docker start $(NAME)
 
# Update the container
update:
        docker pull $(REPO)
        - docker rm $(NAME)-old
        docker rename $(NAME) $(NAME)-old
        make build
        docker stop $(NAME)-old
        make start
