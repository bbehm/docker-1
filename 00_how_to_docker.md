# 🐳 How to Docker 🐳

### Creating our first VM

The first task is to [create](https://docs.docker.com/machine/reference/create/) a virtual machine with docker-machine

`docker-machine create --driver virtualbox Char`

[Get the ip](https://docs.docker.com/machine/reference/ip/) of the VM with the command

`docker-machine ip Char`

Now we need to run `docker ps` without errors. If we now run `docker ps`we get an error because we are not connected to our VM. We can fix it all in one [command](https://docs.docker.com/v17.09/machine/reference/env/):

`eval $(docker-machine env Char)`

### Fetching the hello-world container

[Fetch](https://docs.docker.com/engine/reference/commandline/pull/) using `docker pull hello-world` and then [launch](https://docs.docker.com/engine/reference/run/) using `docker run hello-world`

### Launching an nginx container

`docker run -d -p 5000:80 --name overlord --restart=always nginx`

The -d flag means that it's detached, then we attach its port 80 to port 5000 of our VM Char. We assign the name to be __overlord__ and restart mode as always. Finally we define the container to be nginx.

Now we should be able to access the container at `http://ip.address.of.char:5000/`

Finally, the ip address of overlord can be fetched without actually starting its shell with the [__inspect__](https://docs.docker.com/engine/reference/commandline/inspect/) command

`docker inspect -f '{{ .NetworkSettings.IPAddress }}' overlord`

### Launching an [alpine](https://hub.docker.com/_/alpine) container shell

We want to create an alpine container from which we launch a shell. The container should remove itself once the execution is done. By adding the flags __i__ and __t__ we tell Docker we want an __interactive__ session and allocate a pseudo __TTY__ (a pseudo terminal). More info [here](https://stackoverflow.com/questions/35689628/starting-a-shell-in-the-docker-alpine-container#%20alpine-container/43564198#43564198). The __--rm__ means that we automatically remove the container when it exits.

`docker run -it --rm alpine /bin/sh`

### Creating a shell inside a Debian container where we have everything we need to compile C source code and push it onto a git repo

First we need to `docker run -it --rm debian` to create the shell.

Then we can run the command:

```
apt-get update && apt-get upgrade -y && apt-get install -y build-essential git vim
```
Here we first check if we need to update any packages and then we install the packages we need ([build-essential](https://packages.ubuntu.com/xenial/build-essential) and git + vim to test code). The -y flag (--assume-yes) assumes yes to all prompts.

### Creating a [volume](https://docs.docker.com/storage/volumes/)

`docker volume create hatchery`

Now we have a volume called hatchery. We can list all existing volumes with the command `docker volume ls`.

### Launching a [MySQL](https://hub.docker.com/_/mysql) container as a background task

We will create the container (named spawning-pool) so that it restarts on it's own and stores the database (named Zerglings) in the Hatchery volume that we created.

- We make it __--restart=on-failure:10__.
- The __-d__ flag means detach (the container runs in the background).
- The __-e__ flag means that we specify the environment variables
  - __MYSQL_ROOT_PASSWORD__ to set password
  - __MYSQL_DATABASE__ to specify database name to zerglings, after that we add __-v__ with the Volume and its path
  - Finally, *mysql --default-authentication-plugin=mysql_native_password* is needed for wordpress in later exercises
  
```
docker run -d --name spawning-pool --restart=on-failure:10 -e MYSQL_ROOT_PASSWORD=Kerrigan -e MYSQL_DATABASE=zerglings -v hatchery:/var/lib/mysql mysql --default-authentication-plugin=mysql_native_password
```
To check that everything is configured correctly we can run
```
docker inspect -f '{{.Config.Env}}' spawning-pool
```
### Launching a [Wordpress](https://hub.docker.com/_/wordpress) container

Again as a background task, the container's (named lair) port 80 should be bound the port 8080 of the VM. It should be able to use the spawning-pool container as a database service.

- with __-p 8080:80__ we specify the port connection
- with __--link spawning-pool__ we link it to the database
  - here we again specify the WORDPRESS_DB_HOST='spawning-pool', WORDPRESS_DB_USER='root', WORDPRESS_DB_PASSWORD and WORDPRESS_DB_NAME='zerglings'
  
```
docker run -d --name lair -p 8080:80 --link spawning-pool -e WORDPRESS_DB_HOST='spawning-pool' -e WORDPRESS_DB_USER='root' -e WORDPRESS_DB_PASSWORD='Kerrigan' -e WORDPRESS_DB_NAME='zerglings' wordpress
```
We can check it out in a web browser using `http://IP.of.the.VM.8080/`

### Launching a [phpMyAdmin](https://hub.docker.com/r/phpmyadmin/phpmyadmin/) container

Here when we connect the phpMyAdmin container to the MySQL database - check out full tutorial [here](https://medium.com/@migueldoctor/run-mysql-phpmyadmin-locally-in-3-steps-using-docker-74eb735fa1fc). The *--link* option provides access to another container running in the host. We need to specify the name of our container (*spawning-pool*) and the resource accessed (*db*).
```
docker run -d --name roach-warden -p 8081:80 --link spawning-pool:db phpmyadmin/phpmyadmin
```
Without running the __spawning-pool__ shell we can look up the container's [log in real time](https://success.mirantis.com/article/view-realtime-container-logging) using the command
```
docker logs -f spawning-pool
```

### Displaying active containers and relaunching containers

- To [display active containers](https://docs.docker.com/engine/reference/commandline/ps/) on a VM we use the command `docker ps`
- To [restart](https://docs.docker.com/engine/reference/commandline/restart/) the overlord container we use the command `docker restart overlord`

### Launching a [Python](https://hub.docker.com/_/python) container with [Flask](https://palletsprojects.com/p/flask/)

`docker run -v ~/:/root --name Abathur -p 3000:3000 -dit python:2-slim`

To install Flask we need to run a command within the Python container, for this we use [docker exec](https://docs.docker.com/engine/reference/commandline/exec/).

`docker exec Abathur pip install Flask`

We have to write our code into hello.py and then by running the command
`docker exec -e FLASK_APP=/root/hello.py Abathur flask run --host=0.0.0.0 --port=3000`
it can be accessed on `http://IP.of.the.VM.3000/`

### Creating a local [swarm](https://docs.docker.com/engine/swarm/admin_guide/)

[What is a Docker swarm?](https://www.sumologic.com/glossary/docker-swarm/)

First we need to initialize a swarm and connect it to the IP of the swarm manager (*Char*)

```
docker swarm init --advertise-addr $(docker-machine ip Char)
```
We can check that Char is the manager with the command `docker node ls` or `docker info`.

### Creating another VM and make it a worker of the local swarm

Let's create another VM called Aiur `docker-machine create --driver virtualbox Aiur`.

With the following command we can add Aiur as a worker to the swarm while being connected to the Char VM. We use the command [__docker swarm join__](https://docs.docker.com/engine/reference/commandline/swarm_join/), the port *2377* is defined in the documentation. Being a worker basically means not being the manager.

```
docker-machine ssh Aiur "docker swarm join --token $(docker swarm join-token worker -q) $(docker-machine ip Char):2377"
```
Now we can again check that the command was succesful with `docker node ls`.

### Creating an overlay-type internal network

We can create an overlay internal network called overmind with the command `docker network create -d overlay overmind`.

### Launching a [rabbitmq](https://hub.docker.com/_/rabbitmq) service

Read [this](https://docs.docker.com/engine/swarm/how-swarm-mode-works/services/) to find out how services work. We define the name to be __orbital-command__ and it to be on the __overmind__ network.

```
docker service create --name orbital-command --network overmind -e RABBITMQ_DEFAULT_USER=username -e RABBITMQ_DEFAULT_PASS=password rabbitmq
```
We can list all the services of the local swarm with the command `docker service ls`.

### Launching a [42school/engineering-bay](https://hub.docker.com/r/42school/engineering-bay/) service in two replicas

The service will be named __engineering-bay__ and will be on the __overmind__ network.
```
docker service create --name engineering-bay --network overmind --replicas 2 -e OC_USERNAME=bianca -e OC_PASSWD=bianca 42school/engineering-bay
```
We can check that the two replicas are running with the command `docker service ps engineering-bay`.

To get the real-time logs of the service, we use the command: `docker service logs engineering-bay`.

Now let's launch a Launch a [42school/marine-squad](https://hub.docker.com/r/42school/marine-squad/) in to replicas. This will be named __marines__ and will be on the __overmind__ network. Check with `docker service ls`. List all tasks with `docker service ps marines`.

### [Scaling](https://docs.docker.com/engine/reference/commandline/service_scale/) the marines to 20

By using the docker service scale command we can increase the amount of marines to 20 with the command `docker service scale -d marines=20`.

### Deleting services, containers, images and virtual machines

