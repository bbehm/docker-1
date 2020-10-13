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

### Ex01 - Building my own Teamspeak server

Using a debian image we will add the appropriate sources to create a TeamSpeak server.

First we state that we want a debian image `FROM debian`, then we need to add the `ENV TS3SERVER_LICENSE=accept` for the server to start.
The `EXPOSE` part informs Docker what network to listen to, the specified ports are the one to the teamspeak host.


