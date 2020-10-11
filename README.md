# Docker 🐳

A Hive Helsinki project on handling docker and docker-machine and understanding the idea of containerization of services. The project consists of three parts:

1. How to Docker
2. Dockerfiles
3. Bonus part

The most important resource in learning Docker: [Docker docs](https://docs.docker.com/)

---

## How to Docker

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



