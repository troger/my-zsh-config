export TEST_CLID_PATH='/opt/instance.clid'

alias cpjar='cp -r `find . -path ./*-distribution* -prune -o \( -iname "*SNAPSHOT.jar" -print \) `'
alias cpweb='cp -r `find . -path "*/src/main/resources/web/nuxeo.war" -exec echo {}/ \;`'

compctl -k "(gui nogui help start stop restart configure wizard console status startbg restartbg pack mp-purge mp-list mp-init mp-add mp-install mp-uninstall mp-remove mp-reset -dc)" "*nuxeoctl"

gitf() {
  for dir in . *; do
    if [ -d "$dir"/.git ]; then
      echo "[$dir]"
      (cd "$dir" ; git "$@")
      echo
    fi
  done
}

gitfa() {
   ADDONS=$(mvn help:effective-pom -N|grep '<module>' |cut -d ">" -f 2 |cut -d "<" -f 1)
   for dir in $ADDONS; do
     if [ -d "$dir"/.git ]; then
       echo "[$dir]"
       (cd "$dir" ; git "$@")
       echo
     fi
   done
}

nxfullbuild() {
  cd ~/work/code/nuxeo
  gitf co master
  gfspull
  cd addons/
  gitf co master
  gfspull
  cd ..

  mvn clean install -DskipTests=true -Paddons $@
}

nuxeoctl() {
  NUXEOCTL=./bin/nuxeoctl

  if [ ! -f $NUXEOCTL ]; then
      echo "Not in a Nuxeo Server!"
      return 1
  fi

  $NUXEOCTL "$@" | awk '
    /INFO/ { print "\033[34m" $0 "\033[0m" ;next}
    /WARN/ { print "\033[33m" $0 "\033[0m" ;next}
    /ERROR/ { print "\033[31m" $0 "\033[0m" ;next}
    1 {print}
  '
}

nxconsole() {
  nuxeoctl console
}

nxstart() {
  nuxeoctl start
  tail -f log/server.log | awk '
    /INFO/ { print "\033[34m" $0 "\033[0m" ;next}
    /WARN/ { print "\033[33m" $0 "\033[0m" ;next}
    /ERROR/ { print "\033[31m" $0 "\033[0m" ;next}
    1 {print}
  '
}

nxstop() {
  nuxeoctl stop
}

nxrestart() {
  nuxeoctl restart
  tail -f log/server.log | awk '
    /INFO/ { print "\033[34m" $0 "\033[0m" ;next}
    /WARN/ { print "\033[33m" $0 "\033[0m" ;next}
    /ERROR/ { print "\033[31m" $0 "\033[0m" ;next}
    1 {print}
  '
}

nxweb() {
  cpweb $NUXEO_HOME/nxserver/nuxeo.war/
}

alias nx='cd /opt/nuxeo'

nuxeo-configure() {
  NUXEO_CONF=./bin/nuxeo.conf

  if [ ! -f $NUXEO_CONF ]; then
      echo "Not in a Nuxeo Server!"
      return 1
  fi

  if [ -z "$1" ]; then
    echo 'Usage: nuxeo-configure mongo|postgres|h2|reset'
    return 1
  fi

  NUXEOCTL=./bin/nuxeoctl
  chmod +x $NUXEOCTL

  if [ $1 == "reset" ]; then
    sed -i '' '/### NUXEO CONFIGURE BEGIN/,/### NUXEO CONFIGURE END/d' $NUXEO_CONF
    return
  fi

  if grep -q "NUXEO CONFIGURE BEGIN" "$NUXEO_CONF"; then
    echo "Server already configured!"
    return 1
  fi

  cat << EOF >> $NUXEO_CONF
### NUXEO CONFIGURE BEGIN
EOF

  if [ $1 == "mongo" ]; then
    cp $TEST_CLID_PATH /opt/nxdata/mongo/
    cat << EOF >> $NUXEO_CONF
nuxeo.data.dir=/opt/nxdata/mongo
nuxeo.templates=default,mongodb
EOF
  elif [ $1 == "postgres" ]; then
    cp $TEST_CLID_PATH /opt/nxdata/postgres/
    cat << EOF >> $NUXEO_CONF
nuxeo.data.dir=/opt/nxdata/postgres
nuxeo.templates=default,postgresql
EOF
  elif [ $1 == "h2" ]; then
    cp $TEST_CLID_PATH /opt/nxdata/h2/
    cat << EOF >> $NUXEO_CONF
nuxeo.data.dir=/opt/nxdata/h2
nuxeo.templates=default
EOF
  else
    echo 'Usage: nuxeo-configure mongo|postgres|h2|reset'
    return 1
  fi

  cat << EOF >> $NUXEO_CONF
nuxeo.redis.enabled=true
nuxeo.redis.host=localhost
EOF

  cat << EOF >> $NUXEO_CONF
#elasticsearch.client=RestClient
elasticsearch.addressList=localhost:9300
elasticsearch.clusterName=elasticsearch
elasticsearch.indexName=nuxeo
elasticsearch.indexNumberOfReplicas=0
elasticsearch.httpReadOnly.baseUrl=http://localhost:9200/
audit.elasticsearch.enabled=true
audit.elasticsearch.indexName=audit
seqgen.elasticsearch.indexName=uidgen
EOF

  cat << EOF >> $NUXEO_CONF
mail.transport.host=mail.in.nuxeo.com
mail.transport.port=25
mail.from=devnull@nuxeo.com
EOF

  cat << EOF >> $NUXEO_CONF
org.nuxeo.dev=true
JAVA_OPTS=$JAVA_OPTS -Xdebug -Xrunjdwp:transport=dt_socket,address=8787,server=y,suspend=n
nuxeo.wizard.done=true
EOF

    cat << EOF >> $NUXEO_CONF
### NUXEO CONFIGURE END
EOF

}

nuxeo-stack() {
  nuxeo_stack_file=$HOME/.nuxeo-stack
  if [ "$1" == "stop" ]; then
    compose_options=$(<$nuxeo_stack_file)
    eval "docker-compose $compose_options stop"
    return
  elif [ "$1" == "start" ]; then
    compose_options="--file /opt/stack/docker-compose.yml"
    if [ "$2" == "mongo" ]; then
      compose_options="$compose_options --file /opt/stack/mongo/docker-compose.yml"
    elif [ "$2" == "postgres" ]; then
      compose_options="$compose_options --file /opt/stack/postgres/docker-compose.yml"
    else
      echo 'Launching default stack without any DB'
    fi
    eval "docker-compose $compose_options up -d"
    echo $compose_options >! $nuxeo_stack_file
    return
  fi

  echo 'Usage: nuxeo-stack start mongo|postgres'
  echo '       nuxeo-stack stop'
  return 1
}