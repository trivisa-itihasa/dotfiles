# ~/.zshrc または ~/dotfiles/.zshrc

# 基本設定
export EDITOR=vim
export LANG=ja_JP.UTF-8

# zsh設定
setopt AUTO_CD
setopt CORRECT
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000

# プラットフォーム判定
case $OSTYPE in
  darwin*)
    # macOS設定
    export CLICOLOR=1
    export LSCOLORS=ExFxBxDxCxegedabagacad
    
    # Homebrew PATH
    if [[ -d /opt/homebrew/bin ]]; then
      export PATH="/opt/homebrew/bin:$PATH"
    fi
    if [[ -d /usr/local/bin ]]; then
      export PATH="/usr/local/bin:$PATH"
    fi
    ;;
  linux*)
    # Linux/WSL設定
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    
    # WSL固有設定
    if grep -qi microsoft /proc/version 2>/dev/null; then
      export DISPLAY=$(ip route list default | awk '{print $3}'):0
    fi
    ;;
esac

# 共通エイリアス
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'

# Git エイリアス
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'

# Starship初期化
eval "$(starship init zsh)"

# ローカル設定があれば読み込み
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

