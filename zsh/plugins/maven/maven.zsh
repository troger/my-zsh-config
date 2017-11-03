alias mvn2='/usr/local/Cellar/maven2/2.2.1/bin/mvn'
alias mvn3='/usr/local/Cellar/maven30/3.0.5/bin/mvn'
alias mvngwt='/usr/bin/mvn'
alias mvnnotest='mvn -DskipTests=true'
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

export MAVEN_OPTS="-Xms2048m -Xmx4096m"

export ANT_OPTS="-Xms256m -Xmx1024m"
