ZSH=$(HOME)/.zsh
ZSHRC=$(HOME)/.zshrc

install:
	@!(ls $(ZSHRC) > /dev/null 2> /dev/null) || mv $(ZSHRC) $(PWD)/zshrc.bak
	@!(ls $(ZSH) > /dev/null 2> /dev/null) || mv $(ZSH) $(PWD)/zsh.bak

	ln -s $(PWD)/zsh $(ZSH)
	ln -s $(PWD)/zshrc $(ZSHRC)
	@echo "zsh config successfully installed."

