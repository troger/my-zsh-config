NUXEO_HOME='/opt/nuxeo'

alias cpjar='cp -r `find . -path ./*-distribution* -prune -o \( -iname "*SNAPSHOT.jar" -print \) `'
alias ooheadless='/Applications/OpenOffice.org.app/Contents/MacOS/soffice.bin -headless -nofirststartwizard -accept="socket,host=localhost,port=8100;urp;StarOffice.Service"'


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
