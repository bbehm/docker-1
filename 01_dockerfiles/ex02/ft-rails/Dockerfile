# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: bbehm <bbehm@student.hive.fi>              +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/10/15 11:30:10 by bbehm             #+#    #+#              #
#    Updated: 2020/10/15 14:27:33 by bbehm            ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# doesn't render the site properly... I think?

FROM ruby:2.5.1
MAINTAINER bbehm@student.hive.fi

RUN apt-get update && apt-get install -y nodejs
RUN gem install rails --version 5.2.0

RUN mkdir -p /opt/app
WORKDIR /opt/app

ONBUILD COPY app /opt/app
ONBUILD RUN bundle install && rake db:create && rake db:migrate && rake db:seed
