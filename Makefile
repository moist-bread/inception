# -->┊( VARIABLES )┊.´-★☆★
NAME = raquels-inception
COMPOSE_LOCATION = .


# -->┊( STANDARD RULES )┊.´-★☆★
all: build up

build:
	docker compose build
	$(M_BUILD)

up:
	docker compose up -d
	$(M_UP)
	$(M_START)

start:
	docker compose start
	$(M_START)

fclean: down destroy
	$(M_CLEAN)

down:
	docker compose down
	$(M_DOWN)

destroy:
	docker compose down -v

stop:
	docker compose stop

restart: stop up
	docker compose up -d

re:	fclean all
	$(M_RE)


# -->┊( UTIL RULES )┊.´-★☆★
logs:
	docker compose logs --tail=100 -f

ps:
	docker compose ps

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
M_BUILD		= @echo "\n$(BLK)-->┊$(GRN)  Built: $(BBLU)image for $(NAME) $(BLK)$(DEF)\n"
M_UP		= @echo "\n$(BLK)-->┊$(GRN)  Created: $(BBLU)$(NAME) container$(BLK)$(DEF)"
M_START		= @echo   "$(BLK)-->┊$(GRN)  Started: $(DEF)$(BLUB) $(NAME) container $(BLK)$(DEF)\n"
M_DOWN		= @echo "\n$(BLK)-->┊$(BLU)  Downed:	$(DEF)$(BLUB) $(NAME) container$(BLK)$(DEF)\n"
M_CLEAN		= @echo "\n$(BLK)-->┊$(GRN)  Removed: $(DEF)$(BLUB) $(NAME) $(BLK)$(DEF)\n"
M_RE		= @echo "\n$(BLK)... $(BLU)  Re Done:	$(DEF)$(BCYN) $(NAME) is ready !!$(DEF)"
