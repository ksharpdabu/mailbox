all: help
.PHONY: all

.PHONY: help
help:
		@echo "***********************************"
		@echo " - start_web"
		@echo " - restart_web"
		@echo " - start_mariadb"
		@echo " - start_mariadb_client"
		@echo " - run_cmd"


.PHONY: restart_web
restart_web:
		-docker stop -t 5 mailbox-prod-web
		-docker rm mailbox-prod-web
		-make start_web
		-docker stop -t 5 mailbox-prod-web-2
		-docker rm mailbox-prod-web-2
		-make start_web

.PHONY: start_web
start_web:
		-docker run -d --name mailbox-prod-web                                 \
					--link mailbox-mariadb-prod:MARIADB                        \
					--log-opt max-size=64m                                     \
					--log-opt max-file=1                                       \
					--restart=always                                           \
					-p 127.0.0.1:8801:8801                                     \
					toomore/mailbox:cmd mailbox_server
		-docker run -d --name mailbox-prod-web-2                               \
					--link mailbox-mariadb-prod:MARIADB                        \
					--log-opt max-size=64m                                     \
					--log-opt max-file=1                                       \
					--restart=always                                           \
					-p 127.0.0.1:8802:8801                                     \
					toomore/mailbox:cmd mailbox_server

.PHONY: start_mariadb
start_mariadb:
		-docker run -d --name mailbox-mariadb-prod                             \
					-v /srv/mailbox_mariadb_prod:/var/lib/mysql                \
					--log-opt max-size=64m                                     \
					--log-opt max-file=1                                       \
					-e MYSQL_ROOT_PASSWORD=mailboxdbs                          \
					-e CHARACTER_SET_SERVER='utf8'                             \
					-e COLLATION_SERVER='utf8_general_ci'                      \
					-e INIT_CONNECT='SET NAMES utf8'                           \
					mariadb:10.1.23

.PHONY: start_mariadb_client
start_mariadb_client:
		-docker run -it --rm --link mailbox-mariadb-prod:MARIADB               \
					-v $(shell pwd)/sql:/sql                                   \
					-v $(shell pwd)/mariadb.cnf:/etc/mysql/conf.d/mariadb.cnf  \
					mariadb:10.1.23 bash

.PHONY: run_cmd
run_cmd:
		-docker run -it --rm                                                   \
					--link mailbox-mariadb-prod:MARIADB                        \
					-v $(shell pwd)/csv:/csv                                   \
					-e "mailbox_ses_key=???"                                   \
					-e "mailbox_ses_token=???"                                 \
					-e "mailbox_ses_sender=???"                                \
					-e "mailbox_web_site=???"                                  \
					toomore/mailbox:cmd sh