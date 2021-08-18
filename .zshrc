# Use powerline
USE_POWERLINE="true"
# Source manjaro-zsh-configuration
if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
  source /usr/share/zsh/manjaro-zsh-config
fi
# Use manjaro zsh prompt
if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
  source /usr/share/zsh/manjaro-zsh-prompt
fi
# Aliases
alias py='python3'
alias update='sudo pacman -Syu; yay -Syu'
alias fourier='ssh epinkston@fourier.cs.iit.edu'
alias install='sudo pacman -Sy'
alias ..='cd ..'

