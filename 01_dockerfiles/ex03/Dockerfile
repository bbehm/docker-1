# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: bbehm <bbehm@student.hive.fi>              +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/10/15 14:52:43 by bbehm             #+#    #+#              #
#    Updated: 2020/10/16 15:50:32 by bbehm            ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM debian
MAINTAINER bbehm@student.hive.fi

RUN apt-get update -y && apt-get upgrade -y &&\
	apt-get install -y wget openssh-server ca-certificates postfix

RUN wget https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh \
	&& bash script.deb.sh

RUN apt-get install gitlab-ce

RUN sed -i "s/# grafana\['enable'\] = true/grafana['enable'] = false/g" /etc/gitlab/gitlab.rb

EXPOSE 443 80 22

ENTRYPOINT service ssh start && (/opt/gitlab/embedded/bin/runsvdir-start &) && gitlab-ctl reconfigure && gitlab-ctl tail