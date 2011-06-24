alias hgl='hg glog | less'
alias hgb='hg branch'
alias hgbs='hg branches'
alias hgfpup='hgf pull && hgx 5.3 1.6 up'
alias hgci='hg ci -m'


# functions
hgf() {
  for dir in . nuxeo-*; do
    if [ -d "$dir"/.hg ]; then
      echo "[$dir]"
      (cd "$dir" && hg "$@")
    fi
  done
}

hgx() {
  NXP=$1
  NXC=$2
  shift 2;
  if [ -d .hg ]; then
    echo $PWD
    hg $@ $NXP
    # NXC
    (echo nuxeo-common ; cd nuxeo-common; hg $@ $NXC || true)
    (echo nuxeo-runtime ; cd nuxeo-runtime; hg $@ $NXC || true)
    (echo nuxeo-core ; cd nuxeo-core; hg $@ $NXC || true)
    # NXP
    (echo nuxeo-theme ; cd nuxeo-theme; hg $@ $NXP || true)
    (echo nuxeo-shell ; cd nuxeo-shell; hg $@ $NXP || true)
    (echo nuxeo-services ; cd nuxeo-services && hg $@ $NXP || true)
    (echo nuxeo-jsf ; cd nuxeo-jsf && hg $@ $NXP || true)
    (echo nuxeo-features ; cd nuxeo-features && hg $@ $NXP || true)
    (echo nuxeo-dm ; cd nuxeo-dm && hg $@ $NXP || true)
    (echo nuxeo-webengine ; cd nuxeo-webengine;
          if [ "$NXP" = "5.1" ]; then hg up -C 000000000000 || true; else hg $@ $NXP || true; fi)
    (echo nuxeo-gwt ; cd nuxeo-gwt; 
          if [ "$NXP" = "5.1" ]; then hg up -C 000000000000 || true; else hg $@ $NXP || true; fi)
    (echo nuxeo-distribution ; cd nuxeo-distribution; hg $@ $NXP || true)
  fi
}

