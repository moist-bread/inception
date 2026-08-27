# -->┊( VARIABLES )┊.´-★☆★
NAME = inception_rduro-pe
YAML_PATH = ./srcs/docker-compose.yml

# -->┊( STANDARD RULES )┊.´-★☆★
all: up

setup:
	@chmod +x var_setup.sh
	@bash var_setup.sh
	@sudo cat /etc/hosts | grep rduro-pe.42.fr > /dev/null || sudo sh -c "echo '127.0.0.1 rduro-pe.42.fr' >> /etc/hosts"
	$(M_SETUP)

build: setup
	docker compose -f $(YAML_PATH) build
	$(M_BUILD)

up: build
	mkdir -p /home/rduro-pe/data/mariadb /home/rduro-pe/data/wordpress
# 	mkdir -p ./srcs/services/mariadb/data ./srcs/services/wordpress/data
	$(M_UP)
	$(M_START)
	docker compose -f $(YAML_PATH) up

start:
	$(M_START)
	docker compose -f $(YAML_PATH) start

stop:
	docker compose -f $(YAML_PATH) stop
#docker stop $(docker ps -qa)

fclean: down destroy
	$(M_CLEAN)
	docker system prune -a -f --volumes
	@sudo rm -rf ./srcs/secrets ./srcs/.env
	@sudo rm -rf /home/rduro-pe/data/mariadb /home/rduro-pe/data/wordpress
# 	@sudo rm -rf ./srcs/services/mariadb/data ./srcs/services/wordpress/data
	$(M_SET_CLEAN)

down:
	docker compose -f $(YAML_PATH) down
	$(M_DOWN)

destroy:
	docker compose -f $(YAML_PATH) down -v


restart: stop up
	docker compose -f $(YAML_PATH) up -d

re:	fclean all
	$(M_RE)


# -->┊( UTIL RULES )┊.´-★☆★
logs:
	docker compose -f $(YAML_PATH) logs --tail=100 -f

ps:
	docker compose -f $(YAML_PATH) ps

help:
	@echo "do you feel helped?"

.PHONY: all build up start down stop destroy restart logs ps help

# -->┊( COSMETICS )┊.´-★☆★

#-‵,┊ normal colors
DEF	=	\e[0;39m
BLK	=	\e[0;30m
BLU	=	\e[0;34m
MAG =	\e[0;35m
GRN	=	\e[0;32m

#-‵,┊ bold colors
BCYN	=	\e[1;36m
BBLU	=	\e[1;34m

#-‵,┊ background colors
CYNB	=	\e[46m
YELB	=	\e[43m
BLUB	=	\e[44m

#-‵,┊ messages
M_SETUP		= @echo "\n$(BLK)-->┊$(GRN)  Setup: $(BBLU)created domain, .env and secrets$(BLK)$(DEF)\n"
M_BUILD		= @echo "\n$(BLK)-->┊$(GRN)  Built: $(BBLU)image for $(NAME) $(BLK)$(DEF)\n"
M_UP		= @echo "\n$(BLK)-->┊$(GRN)  Created: $(BBLU)$(NAME) container$(BLK)$(DEF)"
M_START		= @echo   "$(BLK)-->┊$(GRN)  Started: $(DEF)$(BLUB) $(NAME) container $(BLK)$(DEF)\n"
M_DOWN		= @echo "\n$(BLK)-->┊$(BLU)  Downed:	$(DEF)$(BLUB) $(NAME) container$(BLK)$(DEF)\n"
M_CLEAN		= @echo "\n$(BLK)-->┊$(GRN)  Removed: $(DEF)$(BLUB) $(NAME) $(BLK)$(DEF)"
M_SET_CLEAN	= @echo "$(BLK)-->┊$(GRN)  Removed: $(DEF)$(BLUB) .env and secrets $(BLK)$(DEF)\n"
M_RE		= @echo "\n$(BLK)... $(BLU)  Re Done:	$(DEF)$(BCYN) $(NAME) is ready !!$(DEF)"
