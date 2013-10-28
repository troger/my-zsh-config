# Script by David Blevins (http://blog.dblevins.com/)
# See http://docs.codehaus.org/display/ninja/setjdk

export JAVA_HOME=`/usr/libexec/java_home`

defaultjdk() {
    local vmdir=/System/Library/Frameworks/JavaVM.framework/Versions
    local ver=${1?Usage: defaultjdk <version>}

    [ -z "$2" ] || error="Too many arguments"
    [ -d $vmdir/$ver ] || error="Unknown JDK version: $ver"
    [ "$(readlink $vmdir/CurrentJDK)" != "$ver" ] || error="JDK already set to $ver"


    if [ -n "$error" ]; then
	echo $error
	return 1
    fi

    echo -n "Setting default JDK & HotSpot to $ver ... "

    if [ "$(/usr/bin/id -u)" != "0" ]; then
	SUDO=sudo
    fi

    $SUDO /bin/rm /System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK
    $SUDO /bin/ln -s $ver /System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK

    echo Done.
}

setjdk() {
    local vmdir=/System/Library/Frameworks/JavaVM.framework/Versions
    local ver=${1?Usage: setjdk <version>}

    [ -d $vmdir/$ver ] || {
	echo Unknown JDK version: $ver
	return 1
    }

    echo -n "Setting this terminal's JDK to $ver ... "

    export JAVA_HOME=$vmdir/$ver/Home
    PATH=$(echo $PATH | tr ':' '\n' | grep -v $vmdir | tr '\n' ':')
    export PATH=$JAVA_HOME/bin:$PATH

    java -version
}

_setjdk_completion() {

    local vmdir=/System/Library/Frameworks/JavaVM.framework/Versions
    local cur=${COMP_WORDS[COMP_CWORD]//\\\\/}
    local options=$(cd $vmdir; ls | grep 1. | tr '\n' ' ')

    reply=($(compgen -W "${options}" ${cur}))
}

