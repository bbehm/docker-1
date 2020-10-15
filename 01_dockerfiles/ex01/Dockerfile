# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: bbehm <bbehm@student.hive.fi>              +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/10/13 19:57:38 by bbehm             #+#    #+#              #
#    Updated: 2020/10/15 12:29:41 by bbehm            ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM debian
ENV TS3SERVER_LICENSE=accept
WORKDIR /home/teamspeak
EXPOSE 9987/udp 10011 30033
RUN apt-get update && apt-get upgrade -y && apt-get install -y wget bzip2 && \
	wget http://dl.4players.de/ts/releases/3.12.1/teamspeak3-server_linux_amd64-3.12.1.tar.bz2 && \
	tar xvf teamspeak3-server_linux_amd64-3.12.1.tar.bz2

WORKDIR teamspeak3-server_linux_amd64
ENTRYPOINT sh ts3server_minimal_runscript.sh
