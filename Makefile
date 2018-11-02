test:
	@echo "Hello World!!"

ln:
	@sh dotfilesLink.sh

install:
	@sh -c "$(curl -fsSL https://raw.githubusercontent.com/wanimaru47/oh-my-zsh/master/tools/install.sh)"
