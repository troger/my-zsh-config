NUXEO_HOME='/opt/nuxeo'

alias cpjar='cp -r `find . -path ./*-distribution* -prune -o \( -iname "*SNAPSHOT.jar" -print \) `'
alias cpweb='cp -r `find . -path "*/src/main/resources/web/nuxeo.war" -exec echo {}/ \;`'
alias ooheadless='/Applications/OpenOffice.org.app/Contents/MacOS/soffice.bin -headless -nofirststartwizard -accept="socket,host=localhost,port=8100;urp;StarOffice.Service"'

compctl -k "(gui nogui help start stop restart configure wizard console status startbg restartbg pack mp-list mp-init mp-add mp-install mp-uninstall mp-remove mp-reset -dc)" "*nuxeoctl"

gitf() {
  for dir in . nuxeo-*; do
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

  mvn2 clean install -DskipTests=true -Paddons $@
}

nuxeoctl() {
  [ -d ./bin ] || return 1
  BASE_PATH=./bin
  NUXEOCTL=$BASE_PATH/nuxeoctl
  NUXEOCONF=$BASE_PATH/nuxeo.conf

  chmod +x $NUXEOCTL

  perl -p -i -e "s/^#?(org.nuxeo.dev=.*)$/\1/g" $NUXEOCONF
  perl -p -i -e "s/^#?(JAVA_OPTS=.*-Xdebug -Xrunjdwp.*)$/\1/g" $NUXEOCONF

  perl -p -i -e "s,^#?(nuxeo.data.dir=).*$,\1/opt/nxdata,g" $NUXEOCONF

  # PostgreSQL
  perl -p -i -e "s/^#?(nuxeo.templates=.*)$/\1,sdk,postgresql/g" $NUXEOCONF
  perl -p -i -e "s/^#?(nuxeo.db.name=).*$/\1nuxeo/g" $NUXEOCONF
  perl -p -i -e "s/^#?(nuxeo.db.user=).*$/\1nuxeo/g" $NUXEOCONF
  perl -p -i -e "s/^#?(nuxeo.db.password=).*$/\1nuxeo/g" $NUXEOCONF
  perl -p -i -e "s/^#?(nuxeo.db.host=).*$/\1localhost/g" $NUXEOCONF
  perl -p -i -e "s/^#?(nuxeo.db.port=).*$/\1\ 5432/g" $NUXEOCONF

  # Mail
  #perl -p -i -e "s/^#?(mail.transport.host=).*$/\1localhost/g" bin/nuxeo.conf
  perl -p -i -e "s/^#?(mail.transport.host=).*$/\1mail.in.nuxeo.com/g" $NUXEOCONF
  perl -p -i -e "s/^#?(mail.transport.port=).*$/\1\ 25/g" $NUXEOCONF
  perl -p -i -e "s/^#?(mail.from=).*$/\1whatyouwant\@whereyouwant.com/g" $NUXEOCONF

  # Wizard
  perl -p -i -e "s/^#?(nuxeo.wizard.done=).*$/\1true/g" $NUXEOCONF

  $NUXEOCTL  "$@"
}

nxconsole() {
  nuxeoctl console | awk '
    /INFO/ { print "\033[34m" $0 "\033[0m" ;next}
    /WARN/ { print "\033[33m" $0 "\033[0m" ;next}
    /ERROR/ { print "\033[31m" $0 "\033[0m" ;next}
    1 {print}
  '
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
