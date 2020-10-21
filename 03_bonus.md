# Containerizing and hosting a MEAN stack application

As a bonus to the docker-1 project I will containerize a MEAN stack application using __docker compose__.

A __MEAN__ stack includes
- *Angular*
- *MongoDB*
- *Express.js*
- *Node.js*

I will host each technology in separate containers on the same host and make them communicate with eachother. This can be done through [Docker Compose](https://docs.docker.com/compose/).

---

| Container 1  | Container 2 | Container 3 |
| ------------- | ------------- | ------------- |
| Angular  | NodeJS + ExpressJS  | MongoDB |
| Front-end | server-side rendering | back-end database |

---

I will create two Dockerfiles, one for the front-end and one for the server-side. Then we will connect them and the database in a docker-compose file.

### Docker Compose

Where you can define your services that make up your app (`docker-compose.yml`) so that they can be run together

How it looks:

```
version: '3.0'

services:
  front-end:
    build: front-end
    ports:
    - "4200:4200"

  server:
    build: server-side
    ports:
    - "3000:3000"
    links:
    - database

  database:
    image: mongo
    ports:
    - "27017:27017"
```

### Running it

```
docker-compose run
docker-compose up
```
