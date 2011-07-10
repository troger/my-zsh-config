alias mvn2='/usr/share/java/maven-2.2.1/bin/mvn'
alias mvn='~/Dropbox/bin/mvnc'
alias mvngwt='/usr/bin/mvn'
alias mvnnotest='mvn -Dmaven.test.skip=true'
alias mci='mvn clean install'
alias mcit='mvnnotest clean install'
alias mcio='mci -o'
alias mciot='mcit -o'
alias mvno='mvn -o'
alias mvne='mvn eclipse:clean eclipse:eclipse -DdownloadSources=true -DdownloadJavadocs=true'
alias mvneo='mvne -o'
alias mvni='mvn idea:clean idea:idea -DdownloadSources=true -DdownloadJavadocs=true'
alias mvnio='mvni -o'
alias mvntd='mvn clean test -Dmaven.surefire.debug'

export MAVEN_OPTS="-Xms256m -Xmx1024m"

export ANT_OPTS="-Xms256m -Xmx1024m"

