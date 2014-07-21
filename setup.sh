
#
# check if <pkg> is already installed
#

installed(){
  which $1 > /dev/null 2>&1
}

#
# install & configure redis
#

redis_install(){

  #
  # `redis` user
  #

  adduser --disabled-password --gecos "" redis

  #
  # build
  #

  cd /tmp \
    && wget http://download.redis.io/redis-stable.tar.gz \
    && tar xvzf redis-stable.tar.gz \
    && cd redis-stable \
    && mkdir -p /etc/redis \
    && cp redis.conf /etc/redis/redis.conf \
    && make \
    && make install

  #
  # upstart
  #

  tee /etc/init/redis-server.conf <<EOF
description "redis server"

setgid redis
setuid redis

start on local-filesystems
stop on shutdown

# redis will fork itself (with standard conf).
expect fork

# respawn unless redis dies 10 times in 5 seconds
respawn
respawn limit 10 5

script
  redis-server /etc/redis/redis.conf
end script
EOF

  #
  # restart
  #

  service redis-server start
}

#
# provision
#

apt-get -y update
installed wget || apt-get install -y wget
installed build-essential || apt-get install -y build-essential
installed redis-server || redis_install
