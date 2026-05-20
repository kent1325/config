# Better history defaults
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history
setopt SHARE_HISTORY          # share history across tabs
setopt HIST_IGNORE_DUPS       # don't store consecutive dupes
setopt HIST_IGNORE_SPACE      # commands starting with space aren't saved
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY

# Safety defaults and QoL
alias rm='rm -i'      # ask before deleting
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'

# Modern CLI replacements
alias ls='eza --icons --group-directories-first'
alias ll='eza -l --icons --git --group-directories-first'
alias la='eza -la --icons --git --group-directories-first'
alias lt='eza --tree --level=2 --icons'
alias cat='bat --paging=never'
alias find='fd'
alias grep='rg'
alias top='btop'
alias vim='nvim'
alias cd='z'  # zoxide — jump to frecent dirs

# Folder traversal shortcuts
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'   # jump back to previous dir

# Common destinations
alias dl='cd ~/Downloads'
alias docs='cd ~/Documents'
alias dev='cd ~/Code'

# Often used shortcuts
alias settings='bat --paging=never ~/.zshrc'

# Git shortcuts
alias g='git'
alias gs='git status -sb'
alias gd='git diff'
alias gds='git diff --staged'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit -m'
alias gca='git commit --amend --no-edit'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gp='git push'
alias gpc='git push --set-upstream origin $(git branch --show-current)'
alias gpl='git pull --rebase'
alias gl='git log --oneline --graph --decorate -20'
alias gla='git log --oneline --graph --decorate --all -30'
alias gst='git stash'
alias gsp='git stash pop'
alias gbrowse='open $(git config --get remote.origin.url | sed "s/git@\(.*\):\(.*\).git/https:\/\/\1\/\2/")' # Opens the GitHub/GitLab page (requires remote)

# Git functions
gcm() { git commit -m "$*"; }                    # gcm fix typo in readme
gacp() { git add -A && git commit -m "$*" && git push; }  # one-shot add+commit+push
gnuke() { git reset --hard && git clean -fd; }   # ☢️ wipe local changes

# mkdir + cd in one step
mkcd() { mkdir -p "$1" && cd "$1"; }

# Extract any archive
extract() {
  case "$1" in
    *.tar.bz2)  tar xjf "$1"   ;;
    *.tar.gz)   tar xzf "$1"   ;;
    *.tar.xz)   tar xJf "$1"   ;;
    *.bz2)      bunzip2 "$1"   ;;
    *.gz)       gunzip "$1"    ;;
    *.tar)      tar xf "$1"    ;;
    *.zip)      unzip "$1"     ;;
    *.7z)       7z x "$1"      ;;
    *)          echo "Don't know how to extract '$1'" ;;
  esac
}

# Quick HTTP server in current dir
# serve() { python3 -m http.server "${1:-8000}"; }

# What's eating port N?  ->  port 3000
# port() { lsof -i ":$1"; }

# Kill whatever is on a port
# killport() { lsof -ti ":$1" | xargs kill -9; }

# Fuzzy-find a file and open in your editor
fe() { local f; f=$(fzf) && ${EDITOR:-nvim} "$f"; }

# Fuzzy-cd into any subdirectory
fcd() { local d; d=$(fd --type d | fzf) && cd "$d"; }

# Show your largest dirs/files here
biggest() { du -sh "${1:-.}"/* 2>/dev/null | sort -hr | head -20; }

# Show/hide hidden files in Finder
alias showfiles='defaults write com.apple.finder AppleShowAllFiles YES && killall Finder'
alias hidefiles='defaults write com.apple.finder AppleShowAllFiles NO && killall Finder'

# Copy/paste from terminal (pbcopy/pbpaste are built-in but handy)
alias copy='pbcopy'
alias paste='pbpaste'

# Get my IPs
alias localip="ipconfig getifaddr en0"
alias publicip="curl -s https://ifconfig.me"

# Flush DNS
# alias flushdns='sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder'

# Open current dir in Finder / VS Code
alias o='open .'
alias c='code .'

# Reload zsh config without restarting shell
alias reload='source ~/.zshrc'

# Theme settings
if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  eval "$(oh-my-posh init zsh --config ~/ZSHThemes.json)"
fi

source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# Zoxide — smarter cd
eval "$(zoxide init zsh)"

# fzf — keybindings (Ctrl-R history, Ctrl-T file picker, Alt-C dir picker)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# or after `brew install fzf`, run: $(brew --prefix)/opt/fzf/install

# Better tab completion
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'  # case-insensitive
