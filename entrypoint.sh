#!/bin/bash

RUBY_MAJOR=$(ruby -v | awk '{split($2,a,"."); print a[2]}')

if [[ $RUBY_MAJOR == 2 ]]; then
  : ${RAILS_VERSION:='~> 4.2'}
elif [[ $RUBY_MAJOR == 3 ]]; then
  : ${RAILS_VERSION:='~> 5.0'}
elif [ $RUBY_MAJOR -ge 4 ]; then
  : ${RAILS_VERSION:='~> 5.2'}
fi

RAILS_VERSION=${RAILS_VERSION%\"}
RAILS_VERSION=${RAILS_VERSION%\'}
RAILS_VERSION=${RAILS_VERSION#\"}
RAILS_VERSION=${RAILS_VERSION#\'}

USER_ID=${LOCAL_USER_ID:-1000}
export HOME=/home/app

echo "Starting with UID : $USER_ID"

if [[ "$USER_ID" != "$(id -u app)" ]]; then
  if [[ "$(cat /etc/issue | grep 'Alpine')" ]]; then
    deluser app;
    addgroup -g $USER_ID app;
    adduser -u $USER_ID -D -G app -s /bin/bash app;
    chown -R app:app /home/app;
  else
    usermod -u $USER_ID app;
    groupmod -g $USER_ID app;
    chown -R $USER_ID:$USER_ID $HOME
    usermod -g $USER_ID app;
  fi
fi

# if we run default command then try to install rails
# that way if we will need to run oneshot command with this image
# e.g. docker run --rm -it krismichalski/rails /bin/bash
# rails instalation will be skipped
if [[ ( "$@" == "/home/app/start.sh" ) || ( "$@" == "rails"* ) || ( "$@" == "rake"* ) || ( "$@" == "bundle"* ) ]]; then
  source /home/app/install_rails.sh
fi

exec /usr/local/bin/gosu app "$@"
