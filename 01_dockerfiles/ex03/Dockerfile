# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: bbehm <bbehm@student.hive.fi>              +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/10/15 14:52:43 by bbehm             #+#    #+#              #
#    Updated: 2020/10/20 15:43:51 by bbehm            ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM debian

RUN apt-get update && apt-get upgrade -y && \
	apt-get install -y curl openssh-server ca-certificates postfix

RUN curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | bash

RUN apt-get install gitlab-ce

EXPOSE 22 80 443

ENTRYPOINT service ssh start && (/opt/gitlab/embedded/bin/runsvdir-start &) && gitlab-ctl reconfigure && gitlab-ctl tail