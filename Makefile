# -->┊( VARIABLES )┊.´-★☆★
NAME = inception_rduro-pe
YAML_PATH = ./srcs/docker-compose.yaml

# -->┊( STANDARD RULES )┊.´-★☆★
all: up

setup:
	@chmod +x var_setup.sh
	@bash var_setup.sh
	$(M_SETUP)

build: setup
	docker compose -f $(YAML_PATH) build
	$(M_BUILD)

up: build
	mkdir -p ./srcs/services/mariadb/data ./srcs/services/wordpress/data
	docker compose -f $(YAML_PATH) up -d
	$(M_UP)
	$(M_START)

start:
	docker compose -f $(YAML_PATH) start
	$(M_START)

stop:
	docker compose -f $(YAML_PATH) stop
#docker stop $(docker ps -qa)

fclean: down destroy
	$(M_CLEAN)
	@rm -rf ./srcs/secrets ./srcs/.env
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
M_SETUP		= @echo "\n$(BLK)-->┊$(GRN)  Setup: $(BBLU)created .env and secrets$(BLK)$(DEF)\n"
M_BUILD		= @echo "\n$(BLK)-->┊$(GRN)  Built: $(BBLU)image for $(NAME) $(BLK)$(DEF)\n"
M_UP		= @echo "\n$(BLK)-->┊$(GRN)  Created: $(BBLU)$(NAME) container$(BLK)$(DEF)"
M_START		= @echo   "$(BLK)-->┊$(GRN)  Started: $(DEF)$(BLUB) $(NAME) container $(BLK)$(DEF)\n"
M_DOWN		= @echo "\n$(BLK)-->┊$(BLU)  Downed:	$(DEF)$(BLUB) $(NAME) container$(BLK)$(DEF)\n"
M_CLEAN		= @echo "\n$(BLK)-->┊$(GRN)  Removed: $(DEF)$(BLUB) $(NAME) $(BLK)$(DEF)"
M_SET_CLEAN	= @echo "$(BLK)-->┊$(GRN)  Removed: $(DEF)$(BLUB) .env and secrets $(BLK)$(DEF)\n"
M_RE		= @echo "\n$(BLK)... $(BLU)  Re Done:	$(DEF)$(BCYN) $(NAME) is ready !!$(DEF)"
