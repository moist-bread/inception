# INCEPTION

## **📖 CHAPTERS**

- [Prerequisites and Setup](#prerequisites-and-setup) 📦
- [Build and Launch](#build-and-launch) 🆙
- [Managing Utilities](#managing-utilities) 👔
- [Storing Project Data](#storing-project-data) 🔐

## **PREREQUISITES AND SETUP**

As mentioned in the README.md file, there’s a script to install the prerequisites (**curl**, **make** and **docker)** for this project:

```bash
./pre_requirements.sh
```

To create the `.env` and `secrets` and other requirements for setup:

```jsx
make setup
```

`make setup` is run by default when running `make`. It adds the correct domain to the hosts, creates the folders needed for the volume creation and runs the var_setup.sh script which creates the `.env` file and the `secret` files.

The secrets can be changed in the var setup file by replacing the pass_gen function with the new values. for the environment variables its just replacing the hard coded values.

## BUILD AND LAUNCH
Clone and move into the project’s root directory:

```jsx
git clone <repo> inception && cd inception
```
To abstract the `docker compose` commands there’s `make` commands for the job. The options are the following:

```jsx
make
```

```jsx
make setup
```

```jsx
make build
```

```jsx
make up
```

```jsx
make down
```

```jsx
make destroy
```

```jsx
make fclean
```

PS: To see what they do and their equivalent docker compose command run them with a `-n`

## MANAGING UTILITIES

To manage the containers the following utilities are present:

```jsx
make start
```

```jsx
make stop
```

```jsx
make restart
```

```jsx
make logs
```

```jsx
make ps
```

## STORING PROJECT DATA

The project data is stored in the `/home/$(USER)/data/mariadb` and `/home/$(USER)/data/wordpress` directories in the host machine. Those folders are created by the Makefile when building and only get deleted when doing `make fclean` (or `make re`). In all other cases the data persists and is used by the WordPress and MariaDB containers via their respective docker volumes created in the docker compose.