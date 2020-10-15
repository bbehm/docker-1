# 🐳 Dockerfiles 🐳

A Dockerfile is a textfile that contains __all commands needed to build a given image__. A guide to best practices for writing Dockerfiles can be found [here](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)!

- __Docker [build](https://docs.docker.com/engine/reference/commandline/build/)__: building an image from a Dockerfile
- Dockerfile [cheat sheet](https://kapeli.com/cheat_sheets/Dockerfile.docset/Contents/Resources/Documents/index)

---

### Ex00 - Building an alpine image with vim

Let's create an alpine image with our favorite text editor (vim) which will launch when we launch the container.

```
FROM alpine
RUN apk update && apk upgrade && apk add vim
ENTRYPOINT vim
```
To test run the Dockerfile we need to run `docker build -t ex00 .`, then `docker run -it --rm ex00`

### Ex01 - Building my own [Teamspeak](https://teamspeak.com/en/) server

Using a debian image we will add the appropriate sources to create a TeamSpeak server.

__In the Dockerfile:__

First we state that we want a debian image `FROM debian`, then we need to add the `ENV TS3SERVER_LICENSE=accept` for the server to start.
The `EXPOSE` part informs Docker what network to listen to, the specified ports are the one to the teamspeak host.

Then we download teamspeak3 using wget
```
RUN apt-get update && apt-get upgrade -y && apt-get install -y wget bzip2 && \
	  wget http://dl.4players.de/ts/releases/3.12.1/teamspeak3-server_linux_amd64-3.12.1.tar.bz2 && \
	  tar xvf teamspeak3-server_linux_amd64-3.12.1.tar.bz2
```
Finally, we define the `WORKDIR teamspeak3-server_linux_amd64` and the `ENTRYPOINT sh ts3server_minimal_runscript.sh`.

__Then:__

- We *docker build* using the command `docker build -t ex01 .`
- And then *docker run* by `docker run -it --rm -p=9987:9987/udp -p=10011:10011 -p=30033:30033 ex01`

When we run it we get a token which we will use to access the teamspeak server through the [teamspeak client](https://teamspeak.com/en/downloads/) (needs to be downloaded separately). In the teamspeak client we need to use the IP of the virtual machine Char as the server address and the token as the server password. 

### Ex02 - Containerizing [Rails](https://rubyonrails.org/) applications

Creating one generic Dockerfile that is called by another.

The generic container should install via a [ruby container](https://hub.docker.com/_/ruby), all the necessary dependencies and then copy the app to the `/opt/app`folder in the container.
- install appropriate gems
- launch migration and db population for the appplication

[__This__](https://docs.docker.com/compose/rails/).

The child Dockerfile should launch the rails server.
```
FROM ft-rails:on-build

EXPOSE 3000
CMD	["rails", "s", "-b", "0.0.0.0", "-p", "3000"]
```

1. `docker build -t ft-rails:on-build .`
2. `docker build -t ex02 . && docker run -it --rm -p 3000:3000 ex02`


