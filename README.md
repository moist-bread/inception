*This project has been created as part of the 42 curriculum by rduro-pe*

# INCEPTION

## **📖 CHAPTERS**

- [Description](#description) 👾
- [Instructions](#instructions) 🏁
- [Resources](#resources) 📚

## **DESCRIPTION**

`Inception` is an introduction to Docker and other technologies such as Databases, Web Servers and Blog Hosting Services.

It also helps develop a better understanding of  System Administration, Bash Scripting and Networking.

For this project we have to setup and configure three Docker Containers with one service each (`NGINX`, `WordPress` and `MariaDB`), building an infrastructure from them by using the capacities that Docker provides, e.i. Docker Compose. 

For a deep dive on all the topics covered by this project, check the categories in [Resources](#resources) 📚.

## **INSTRUCTIONS**

This project has a few dependencies so for ease of use there's a script to install them: 

```bash
./pre_requirements.sh
```

The script installs: **curl**, **make** and **docker**

To run `Inception` simply build and start it with `make` :

```bash
make
```

## PROJECT DESCRIPTION

Docker was used to create the design architecture required in the project’s subject.

By using Docker Compose it’s possible to connect and facilitate communication between multiple micro services, in the specific case of this project, `NGINX`, `WordPress` and `MariaDB`. But instead of using the Official Images from Docker Hub all services were setup and configured from scratch using the Debian image as a starting point. 

More information on how that was done in [Resources](#resources) 📚.

---

> **Virtual Machines vs Docker**
> 

Virtual Machines (VM) make use of `virtualization` whilst Containers use **`containerization`.**  They serve different purposes. The VM runs a whole environment on its own Operating System (OS) which can be useful as it creates an isolated duplicate of a real computer machine, but that also has its down sides, being more resource demanding and more involved to setup.

On the other hand Containers are made to be fast, lightweight and easily to setup and replicate. More information on that in [Docker Concepts](#containers-vs-virtual-machines). 

---

> **Secrets vs Environment Variables**
> 

Docker `secrets` are meant for information that shouldn’t be shared unencrypted, such as passwords, keys and certificates.  Secrets make it easier to control where the sensitive information is known and the container only has access to the secrets while it’s running.

In the case of `environment variables` they are more accessible and flexible, making for an easy way to configure efficiently multiple services, reuse and alter if needed, persisting inside the container.  

---

> **Docker Network vs Host Network**
> 

A `Docker Network` is a virtual network that Docker creates for the containers to communicate. It provides a safe isolated network. The other option, `Host Network`, is faster performance wise but uses directly the Network of the host machine, which can be a security risk. 

---

> **Docker Volumes vs Bind Mounts**
> 

A named `Docker Volume` is capable of storing data persistently for a container. It stores it within a directory on the Docker host but is completely managed by Docker in isolation from the host machine.

A `Bind Mount` is a direct connection from the host machine to the container, making the container very dependant on the host filesystem, which can be prone to failure and pose a security risk.

## **RESOURCES**

During theory research for this project all resources were saved along side explanatory notes that expand on the topics.

    
<details>
<summary><b>Docker Concepts</b></summary>

---

#### Containers VS. Virtual Machines

**`Containerization`** unlike virtualization doesn’t need a hypervisor and a guest OS to function, it uses a **container engine** (ex.: docker) that runs directly on the host OS whilst keeping everything isolated.

**`namespaces`** and **`cgroups`** (control groups) are concepts used by containers.

A **`namespace`** wraps a resource to make it appear to the processes within the namespace that they have their own isolated instance of the resource. resources: mount point, host/domain, interprocess communication (ipc mechanism examples: message queues, semaphore, and shared memory [[sysvipc(7)](https://man7.org/linux/man-pages/man7/sysvipc.7.html)]), pids, network, users/groups.

A **`cgroup`** manages the resource usage of a group of processes. resources: CPU, memory, disk I/O, network bandwidth. [[Introduction to Control Groups (Cgroups)](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/6/html/resource_management_guide/ch01)]

A **`container`** is “a standard unit of software that packages up code and all its dependencies so the application runs quickly and reliably from one computing environment to another”. [[What is a Container?](https://www.docker.com/resources/what-container/)]

A container is created from a **`container image`**. A **`container image`** is a template executable package “that includes everything needed to run an application: code, runtime, system tools, system libraries and settings”. after the image has been built it cannot be modified, only rebuilt. the container image becomes a container when run.  [[What is an image? | Docker Docs](https://docs.docker.com/get-started/docker-concepts/the-basics/what-is-an-image/)]

---

#### Container Images and Image Layers

To create a container image you can use a **`Dockerfile`** (works like a config file) where you define the steps needed to create and run a custom image. it can be derived from a previous image. [[What is Docker?](https://docs.docker.com/get-started/docker-overview/#docker-objects)]

The **`Dockerfile`** works in layers, each instruction will add a new layer to the image, so when you rebuild the image only the layers that were changed get rebuilt, because of layer caching. for the layers to work, docker uses two things: **`content-addressable storage`** and **`union filesystems`**. [[Understanding the image layers | Docker Docs](https://docs.docker.com/get-started/docker-concepts/building-images/understanding-image-layers/)]

**`*content-addressable storage`** (CAS):* layers are identified the hash code of its compressed content. if more than one image needs a certain layer they can refer to the same layer on disk making it lighter and faster.

**`*union filesystems`** (OverlayFS):* is created when a container is run from an image and creates a directory for the container. it stacks the layers on top of each other to create a new unified view. [[How Docker Works Internally](https://letsbuildsolutions.com/blog/devops/how-docker-works-internally-namespaces-cgroups-union-filesystems-and-the-oci-runtime/)]

when multiple containers are needed, **docker compose** is helpful to connect them.

[dockerfile]   `*docker build*`   [image]   `*docker run*`   [container]

---
</details>

<details>
<summary><b>Dockerfile</b></summary>

---

#### Dockerfile Purpose and Intructions

- [Dockerfile reference | Docker Docs](https://docs.docker.com/reference/dockerfile/)

a **`Dockerfile`** has a set of ***instructions*** that serve to perform all the commands a user could call on the command line to assemble an image.

*starter instructions*:

- **`parser directives`:** settings for the Dockerfile parser (at top of file);
- **`ARG`:** global variables, can be used in FROM (to use after, (re)declare after). can be overwritten by ENV. whenever the value of an ARG changes it performs a cache miss on use [[Dockerfile –cache-hit-miss flag](https://dockerpros.com/wiki/dockerfile-cache-hit-miss/)];
- **`FROM`:** start built with a base image to work from (ex.: OS).

**`shell and exec form`** are the two syntaxes to write commands for instructions RUN, CMD and ENTRYPOINT.

`**shell** form` is written like a regular string (ex.: a b), it’s better for longer commands and readability. it’s possible to escape the commands into multiple lines. the default command shell (/bin/sh) can be changed with the SHELL instruction (written in exec form).

`**exec** form` is in JSON array syntax (ex.: [“a”, ”b”]), it’s better for ENTRYPOINT and setting default arguments with CMD. it’s also possible to specify a specific command shell, if none is specified it can’t perform expansions.

**`here-documents`** can be used to send the lines following as input for RUN or COPY.

*middle instructions*:

- **`RUN`:** executes commands and creates new layers in the image at built time;
- **`CMD`:** sets the command to be executed in the running container. only one CMD instruction is executed from the Dockerfile, the last one. if there is no executable it can count as a default for the ENTRYPOINT but if the user specifies arguments to *docker run* then they will override the CMD ones [[Understand how CMD and ENTRYPOINT interact](https://docs.docker.com/reference/dockerfile#understand-how-cmd-and-entrypoint-interact)];
- **`COPY`:** copies a local file from *srcs* (as many args are desired) to the image’s filesystem at *dest* (last argument). supports copying from build stages. also relevant is the --chmod flag (ex.: “--chmod=777”, “--chmod=+x”) that changes the files’ mode;
- **`ADD`:** like COPY but doesn't do build stages. instead it can extract .tar files, and get files from urls and gits.

*ending instructions*:

- **`EXPOSE`:** tells Docker that the container listens on those port(s) at runtime. actually “exposing” the port happens in the *docker run* command and flags;
- **`ENTRYPOINT`:** commands that run when the container starts. only one ENTRYPOINT instruction is executed from the Dockerfile, the last one. when in shell form overwrites any CMD.

*other useful things* [[Building best practices | Docker Docs](https://docs.docker.com/build/building/best-practices/)]:

- **`docker build --pull`:** forces a recent base image pull;
- **`docker build --no-cache`:** rebuild all layers from scratch;
- **`apt-get install -y --no-install-recommends *`:** always on the same RUN as apt-get update;
- **`exec`:** use for the last command inside helper scripts to replace the bash process as PID1 so it can detect Unix signals (ie.: SIGTERM). [[Understanding PID 1](https://linuxvox.com/blog/in-linux-what-process-has-the-pid-of-1/), [Uses of the Exec Command in Shell Script](https://www.baeldung.com/linux/exec-command-in-shell-script)]

---
</details>

<details>
<summary><b>Using Docker and Related Concepts</b></summary>

---

#### Introductions to Docker

[Docker in 100 Seconds (video)](https://www.youtube.com/watch?v=Gjnup-PuquQ)

[The Only Docker Tutorial You Need To Get Started (video)](https://www.youtube.com/watch?v=DQdB7wFEygo)

[Docker Crash Course for Absolute Beginners (video)](https://www.youtube.com/watch?v=pg19Z8LL06w)

[Docker do Zero: O que eu faria diferente para aprender? (video)](https://youtu.be/Y6kz884AoME?si=gbADQkQLdLfwdBLk)

***daemon* -** program that runs as a background process, rather than being under the direct control of an interactive user.

---

#### Other Resources

[Install Docker Engine on Debian](https://docs.docker.com/engine/install/debian/)

[Difference Between docker-compose up, down, stop, and start](https://stackoverflow.com/questions/46428420/difference-between-docker-compose-up-down-stop-and-start)

[Storage | Docker Docs](https://docs.docker.com/engine/storage/)

Useful Commands:

- **docker pull (image to pull)**;
- **docker images**;
- **docker ps:** list running containers;
- **docker run --name (container name) -d -p (host port):(container port) (image name):** give it a name, run detacked from terminal, bind hist port to a container port;
- **docker logs/stop/start (CONTAINER ID or NAME)**;
- **docker build -t (image name) (dockerfile folder path):** will follow the docker file instructions in the folder LOCATION and tag the image as NAME;
- **docker stop (container name) && docker rm (container name) && docker rmi (image name)**;
- **docker exec -it (container name) /bin/bash:** enter into the container filesystem [[How to Explore a Docker Container's File System](https://www.tutorialpedia.org/blog/exploring-docker-container-s-file-system/)].

---

</details>

<details>
<summary><b>MariaDB Concepts and Usage</b></summary>

---

#### What is MariaDB and Overall Concepts

- [MariaDB Tutorial - Everything you Need to Know (video)](https://www.youtube.com/watch?v=-b3trv4e5TE)

**`MariaDB`** is a *relational database*, meaning it presents data as a table and provides relational operators, also making use of *primary keys* and *foreign keys* (to “connect” tables). [[Relational database - Wikipedia](https://en.wikipedia.org/wiki/Relational_database)]

For the database to ensure data integrity it follows the **`ACID`** properties:

[[ACID - MariaDB Documentation](https://mariadb.com/docs/general-resources/database-theory/acid-concurrency-control-with-transactions)]

- **`atomicity`**: *all* steps in a transaction must complete, or else it’s a failure;
- **`consistency`**: data storing structure always follows rules or constraints;
- **`isolation`**: data being used is inaccessible to others until the current transaction is complete;
- **`durability`**: effects are permanent after completion.

An **`SQL query`** is a message that is sent to the database that ask for a task to be performed (ex.: SELECT * FROM tasks).

MariaDB’s **`query optimizer`** determines what algorithm is the best fit to perform a query based on the data structure and the schema of how the data is stored and connected.

The possible operations you can ask for in a query are: (**`CRUD`**) Create, Read, Update and Delete.

---

#### How It Stores Its Data and How to Interact With It

When MariaDB runs it sets up its database content inside of the */var/lib/mysql* directory. By default it creates a few tables that it uses internally to function: */mysql, /performance_schema* and */sys*. whenever a new database is added a new directory will be created inside the */var/lib/mysql* directory next to all the other default ones.

When creating a database they have: options *(.opt*), table structure *(.frm)* and table items *(.ibd)*.

The MariaDB configuration files are stored at the */etc/mysql/my.cnf* file and optionally at the */etc/mysql/conf.d/* directory for the use case of having more than one *.cnf file, for mariadb to acknowledge them they need to be called in *my.cnf*.

The commands used inside MariaDB are called statements. [[SQL Statements](https://mariadb.com/docs/server/reference/sql-statements)]

Inside the container, after running MariaDB some useful commands are:

- SHOW DATABASES;
- USE *database_name*;
- SHOW TABLES;
- SELECT *value_a*,*value_b* FROM *table_name* [[SELECT | MariaDB Docs](https://mariadb.com/docs/server/reference/sql-statements/data-manipulation/selecting-data/select)]

---
</details>

<details>
<summary><b>MariaDB Dockerfile / Setup Script</b></summary>

---

#### The Hows and Whys of the MariaDB Dockerfile and Script

**apt-get** is preferred as a package manager for scripts and automations over *apt* because of the consistent output format and the *-y* flag which says yes to prompts during execution, making it run without interaction. [[apt vs apt-get: The Difference| Linuxize](https://linuxize.com/post/apt-vs-apt-get/)]

**mariadbd-safe** is a start up script in MariaDB. it’s recommended as it’s safer (ex.: when it notices a crash it automatically restarts MariaDB). But unfortunately can’t be used as the last command for a container ENTRYPOINT as it doesn’t exit gracefully when stopping the container (needs to be forced) [[mariadbd-safe | MariaDB](https://mariadb.com/docs/server/server-management/starting-and-stopping-mariadb/mariadbd-safe)]

opted to send the MariaDB configs on the start up command instead of using *COPY*. [[Connecting to MariaDB Guide](https://mariadb.com/docs/server/mariadb-quickstart-guides/mariadb-connecting-guide), [How to Change the MySQL Unix Socket File](https://dev.mysql.com/doc/refman/8.4/en/problems-with-mysql-sock.html), [Connecting to MySQL server through socket](https://phoenixnap.com/kb/mysql-server-through-socket-var-run-mysqld-mysqld-sock-2), [mariadbd-safe (Specifying datadir)](https://mariadb.com/docs/server/server-management/starting-and-stopping-mariadb/mariadbd-safe#specifying-datadir)]

creating the folders where MariaDB stores it’s config/sockets to guarantee that they exist and have the correct permissions for MariaDB to be able to create the needed files on reboot [["No such file or directory" when unixsocket does not exist](https://github.com/redis/redis/issues/8081), [MariaDB sock file folder issues - how to fix](https://www.ryadel.com/en/linux-mysql-mariadb-sock-file-folder-socket-fix/)]

Choices:

- skip installing MariaDB again in the script; [[mariadb-install-db | MariaDB](https://mariadb.com/docs/server/clients-and-utilities/deployment-tools/mariadb-install-db)]
- using *&* to run a command as a background process; [[bash - Guide to Process Ids](https://bashcommands.com/bash-get-pid)]
- using *mariadb-admin* to shutdown as it’s more reliable than the SHUTDOWN statement. [[Alternatives to SQL's SHUTDOWN for MariaDB](https://runebook.dev/en/docs/mariadb/shutdown/index)]

---
</details>

<details>
<summary><b>TLS Protocol</b></summary>

---

#### Transport Layer Security / Secure Sockets Layer

- [What is Transport Layer Security? | TLS protocol](https://www.cloudflare.com/learning/ssl/transport-layer-security-tls/)

**`Transport Layer Security`** (TLS) is a security protocol (set of rules) that facilitates privacy and data security for communications over the Internet. it’s mainly used for encrypting the communication between Web Apps and Servers.

TLS evolved from the **`Secure Sockets Layer`** protocol (SSL), because of it, the names are used interchangeably.

Using TLS encryption helps protect a WebApp from data breaches and other attacks, which is why **`HTTPS`** is the standard practice for websites. **`HTTPS`** is an implementation of TLS encryption on top of the HTTP.

**`TLS`** does: *encryption* (hides the data), *authentication* (ensure parties are who they claim to be) and *integrity* (verifies data is not forged or tampered with).

To use TLS a website/app needs to have a **`TLS/SSL certificate`** installed on its Server. the certificate is issued by a certificate authority to the owner of the domain, and contains information about the owner and the server’s public key.

To start a TLS connection a **`TLS handshake`** is performed between client and server. in the handshake the client and server: specify a TLS version (ex.: 1.2, 1.3), pick a cipher suite (algorithm that specifies which keys to use), authentication of the server using the TLS certificate and generate session keys for encryption.

In **`TLS 1.2`** the handshake is made in 2 round trips whilst in **`TLS 1.3`** it’s done in 1 roundtrip, making it faster and more efficient whilst also having safer cipher suites. for compatibility reasons it’s best to allow both versions in a server. [[Differences Between TLS 1.2 and TLS 1.3](https://www.geeksforgeeks.org/computer-networks/differences-between-tls-1-2-and-tls-1-3/), [TLS 1.2 vs TLS 1.3: A Technical Deep Dive](https://www.w3tutorials.net/blog/differences-between-tls-1-2-and-tls-1-3/), [How to check the TLS version](https://support.networkoptix.com/hc/en-us/articles/17314112665111-How-to-check-and-or-change-the-TLS-version)]

---
</details>

<details>
<summary><b>NGINX</b></summary>

---

#### What’s NGINX and How to Use It

**`NGINX`** is an HTTP web server, reverse proxy, content cache, load balancer, TCP/UDP proxy server, and mail proxy server. another server feature NGINX possesses is SSL support, which requires the use of the OpenSSL library. [[nginx.org](nginx.org)]

the **`ngx_http_ssl_module`** is what provides the SSL/TCP support for **`HTTPS`**. to use that module the OpenSSL library is required. **`OpenSSL`** is a toolkit for TLS [[Module ngx_http_ssl_module](https://nginx.org/en/docs/http/ngx_http_ssl_module.html)].

**nginx -t**: tests the configuration file syntax and files mentioned [[NGINX - Command-line parameters](https://nginx.org/en/docs/switches.html)].

***using nginx:***

[What is Nginx (Web Server) and how to install it?](https://www.geeksforgeeks.org/operating-systems/what-is-nginx-web-server-and-how-to-install-it/)

[Deploying NGINX and NGINX Plus with Docker](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-docker/)

[NGINX Tutorial for Beginners](https://www.youtube.com/watch?v=9t9Mp0BGnyI)

---

#### OpenSSL

***using OpenSSL:***

[ossl-guide-introduction - OpenSSL Documentation](https://docs.openssl.org/3.2/man7/ossl-guide-introduction/)

[OpenSSL Documentation Index](https://docs.openssl.org/master/)

[OpenSSL Command Manual](https://docs.openssl.org/3.2/man1/openssl/)

[ossl-guide-tls-introduction - OpenSSL Documentation](https://docs.openssl.org/master/man7/ossl-guide-tls-introduction/)

[Create Your Own SSL Certificate Authority (on Linux) (video)](https://www.youtube.com/watch?v=SlcrTSvMioU)

[req(1) - Linux man page](https://linux.die.net/man/1/req)

[How to Set Up SSL with NGINX (video)](https://www.youtube.com/watch?v=X3Pr5VATOyA)

[Secure Apache with SSL in Docker (video)](https://youtu.be/8A7bO7MDG9Y?si=4tHE0yqQP_DQ5faO)

---

</details>

<details>
<summary><b>WordPress</b></summary>

---

#### Installing and Using WordPress’s CLI

[How to install WordPress – Advanced Administration Handbook](https://developer.wordpress.org/advanced-administration/before-install/howto-install/)

[How to install WordPress DETAILED – Advanced Administration Handbook](https://developer.wordpress.org/advanced-administration/before-install/howto-install/#detailed-instructions)

[Nginx – Advanced Administration Handbook | Developer.WordPress.org](http://developer.wordpress.org/)

[How To Setup WordPress on an Nginx LEMP Server (video)](https://www.youtube.com/watch?v=q1c_66QjRYo)

[Quick Start – WP-CLI – WordPress.org](https://make.wordpress.org/cli/handbook/guides/quick-start/)

[Installing – WP-CLI – WordPress.org](https://make.wordpress.org/cli/handbook/guides/installing/)

[WP-CLI Commands | Developer.WordPress.org](https://developer.wordpress.org/cli/commands/)

[wp core – WP-CLI Command | Developer.WordPress.org](https://developer.wordpress.org/cli/commands/core/)

[Twenty Ten | WordPress Theme](https://wordpress.org/themes/twentyten/)

---

#### WordPress Dockerfile / Setup Script

choices:

- Installing ca-certificates to guarantee curl works correctly in the container [[curl not working (Error #77) for SSL connections](https://stackoverflow.com/questions/17064601/curl-not-working-error-77-for-ssl-connections-on-centos-for-non-root-users)];
- Directly altering the port on the default php config file [[Sed Command in Linux/Unix With Examples](https://www.geeksforgeeks.org/linux-unix/sed-command-in-linux-unix-with-examples/)];
- Waiting and checking if mariadb has created the needed database [[TLS Handshake Fails with “Host Is Not Allowed to Connect”](https://dev.to/gowrishankar/fixing-mariadb-error-2002-hy000-tls-handshake-fails-with-host-is-not-allowed-to-connect-4h05), [Connect to MariaDB from a different machine](https://docs.bitnami.com/general/infrastructure/mariadb/administration/connect-remotely-mariadb/), [How to check if mysql database exists](https://stackoverflow.com/questions/838978/how-to-check-if-mysql-database-exists)];
- Addeing general wordpress rules to the nginx config for general files (non php) [[Nginx – Advanced Administration Handbook | Developer.WordPress.org](https://developer.wordpress.org/advanced-administration/server/web-server/nginx/#general-wordpress-rules)].

---
</details>

<details>
<summary><b>Docker Compose File</b></summary>

---

#### How to use docker compose

- [Compose file reference | Docker Docs](https://docs.docker.com/reference/compose-file/)

docker compose file example: [wordpress - Official Image | Docker Hub](https://hub.docker.com/_/wordpress)

[Volumes | Docker Docs](https://docs.docker.com/engine/storage/volumes/)

[Define and manage volumes in Docker Compose](https://docs.docker.com/reference/compose-file/volumes/)

[Bridge network driver | Docker Docs](https://docs.docker.com/engine/network/drivers/bridge/)

[Docker Volume VS Bind Mount - GeeksforGeeks](https://www.geeksforgeeks.org/devops/docker-volume-vs-bind-mount/)

[Bind mounts | Docker Docs](https://docs.docker.com/engine/storage/bind-mounts/)

[Manage sensitive data with Docker secrets](https://docs.docker.com/engine/swarm/secrets/)

**docker system prune -a -f --volumes**: remove all unused containers, networks, images and volumes.

---
</details>

<details>
<summary><b>Setting Up the VM and Scripting</b></summary>

---

#### Setup of the Virtual Machine

[Downloads – Oracle VirtualBox](https://www.virtualbox.org/wiki/Downloads)

[Installing VirtualBox on Windows? Set Up the Dependencies](https://www.makeuseof.com/setup-dependencies-for-virtualbox-installation-on-windows/)

[Installing Debian via the Internet](https://www.debian.org/distrib/netinst)

[Linux Command to Check User Groups - GeeksforGeeks](https://www.geeksforgeeks.org/linux-unix/how-to-check-the-groups-a-user-belongs-to-in-linux/)

[Demystifying the Linux `sudoers` File: A Comprehensive Guide](https://linuxvox.com/blog/linux-sudoers-file/)

[How to Add a User to the sudoers File in Linux](https://www.howtogeek.com/842739/how-to-add-a-user-to-the-sudoers-file-in-linux/)

[What is ZSH](https://www.howtogeek.com/362409/what-is-zsh-and-why-should-you-use-it-instead-of-bash/)

[Dash to dock GNOME Shell extension](https://micheleg.github.io/dash-to-dock/)

[How to Install and Manage GNOME Shell Extension | Baeldung on Linux](https://www.baeldung.com/linux/gnome-shell-extension)

[How to Add and Delete Users on Debian 13 | Linuxize](https://linuxize.com/post/how-to-add-and-delete-users-on-debian/)

---

#### Scripting

[Linux: Generating Random Strings](https://linuxvox.com/blog/linux-generate-random-string/)

[Bash Functions | Linuxize](https://linuxize.com/post/bash-functions/)

[How to Use Variables in Bash Shell Scripts](https://linuxhandbook.com/courses/bash-beginner/bash-variables/)

[Automate Your Linux Setup: Create a One-Command Installation Script! (video)](https://www.youtube.com/watch?v=1J0Hgr2Nc6c)

[User Input (taking user input in a script) - Bash Scripting Course (pt13) (video)](https://www.youtube.com/watch?v=dpQh0iBILI4&list=PL-my9REMIFtGgiQAXqKPJ5UrLdSkxcLBT&index=13)

[The Complete Bash Scripting Course (playlist)](https://www.youtube.com/playlist?list=PL-my9REMIFtGgiQAXqKPJ5UrLdSkxcLBT)

---

</details>

---

> *Disclosure: AI was not used in any step of this project.*
>