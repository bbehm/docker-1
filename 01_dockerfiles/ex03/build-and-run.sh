#!/bin/bash
docker build -t ex03 . && docker run -it --shm-size=256g --rm -p 8080:80 -p 8022:22 -p 8443:443 --privileged ex03