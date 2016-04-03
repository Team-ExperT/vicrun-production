FROM phusion/passenger-ruby21:0.9.14

MAINTAINER Rizky spondbob@eamca.com

# Set correct environment variables.
ENV HOME /root
# ENV PGUSER postgres
# ENV PGPASSWORD postgres
# ENV PGHOST localhost
# ENV REDISUSER 
# ENV REDISPASSWORD
# ENV REDISHOST

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]
EXPOSE 5780

# If you're using the 'customizable' variant, you need to explicitly opt-in
# for features. Uncomment the features you want:
#
#   Build system and git.
RUN /build/utilities.sh
RUN /build/ruby2.1.sh
RUN apt-get install libpq-dev
RUN rm -f /etc/service/nginx/down
RUN rm /etc/nginx/sites-enabled/default

ADD config/vicrun.conf /etc/nginx/sites-enabled/vicrun.conf
ADD config/vicrun-env.conf /etc/nginx/main.d/vicrun-env.conf

WORKDIR /tmp
ADD vicrun-server/Gemfile /tmp/
ADD vicrun-server/Gemfile.lock /tmp/
RUN bundle install

RUN mkdir /home/app/vicrun


ADD vicrun-server /home/app/vicrun
RUN chown -R app:app /home/app/vicrun

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# RUN echo "app    ALL=(ALL)    NOPASSWD:ALL" >> /etc/sudoers.d/app
# USER app
WORKDIR /home/app/vicrun