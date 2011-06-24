alias showfiles='defaults write com.apple.finder AppleShowAllFiles TRUE; killall Finder'
alias hidefiles='defaults write com.apple.finder AppleShowAllFiles FALSE; killall Finder'

# Recursively delete .DS_Store files
alias rm-dsstore="find . -name '*.DS_Store' -type f -delete"

