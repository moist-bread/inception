# -->┊( VARIABLES )┊.´-★☆★
USER=rduro-pe
NAME = inception_$(USER)
YAML_PATH = ./srcs/docker-compose.yml

# -->┊( STANDARD RULES )┊.´-★☆★
all: up

setup:
	@chmod +x var_setup.sh
	@bash var_setup.sh
	@echo "sudo needed for adding domain to hosts"
	@sudo cat /etc/hosts | grep $(USER).42.fr > /dev/null || sudo sh -c "echo '127.0.0.1 $(USER).42.fr' >> /etc/hosts"
	$(M_SETUP)

build: setup
	docker compose -f $(YAML_PATH) build
	$(M_BUILD)

up: build
	@mkdir -p /home/$(USER)/data/mariadb /home/$(USER)/data/wordpress
	$(M_UP)
	$(M_START)
	docker compose -f $(YAML_PATH) up

down:
	docker compose -f $(YAML_PATH) down
	$(M_DOWN)

destroy:
	docker compose -f $(YAML_PATH) down -v
	docker compose -f $(YAML_PATH) down --rmi local

fclean: down destroy
	@docker system prune -a -f --volumes
	$(M_CLEAN)
	@echo "sudo needed to remove secrets/env and local volume data"
	@sudo rm -rf ./srcs/secrets ./srcs/.env
	@sudo rm -rf /home/$(USER)/data/mariadb /home/$(USER)/data/wordpress
	$(M_SET_CLEAN)

re:	fclean all
	$(M_RE)

# -->┊( UTIL RULES )┊.´-★☆★

start:
	$(M_START)
	docker compose -f $(YAML_PATH) start

stop:
	docker compose -f $(YAML_PATH) stop

restart: stop up

logs:
	docker compose -f $(YAML_PATH) logs --tail=25 -f

ps:
	docker compose -f $(YAML_PATH) ps

.PHONY: all setup build up down destroy fclean start stop restart logs ps

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
M_START		= @echo   "$(BLK)-->┊$(GRN)  Starting: $(DEF)$(BLUB) $(NAME) container $(BLK)$(DEF)\n"
M_DOWN		= @echo "\n$(BLK)-->┊$(BLU)  Downed:	$(DEF)$(BLUB) $(NAME) container$(BLK)$(DEF)\n"
M_CLEAN		= @echo "\n$(BLK)-->┊$(GRN)  Removed: $(DEF)$(BLUB) $(NAME) $(BLK)$(DEF)"
M_SET_CLEAN	= @echo "$(BLK)-->┊$(GRN)  Removed: $(DEF)$(BLUB) .env and secrets $(BLK)$(DEF)\n"
M_RE		= @echo "\n$(BLK)... $(BLU)  Re Done:	$(DEF)$(BCYN) $(NAME) is ready !!$(DEF)"
