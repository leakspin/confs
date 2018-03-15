# .bashrc
# by amg1893
# Help from helmuthdu <3
# OVERALL CONDITIONALS {{{
_islinux=false
[[ "$(uname -s)" =~ Linux|GNU|GNU/* ]] && _islinux=true

_isarch=false
[[ -f /etc/arch-release ]] && _isarch=true

_isxrunning=false
[[ -n "$DISPLAY" ]] && _isxrunning=true

_isroot=false
[[ $UID -eq 0 ]] && _isroot=true

# }}}
# BASH OPTIONS {{{
  shopt -s cdspell                 # Correct cd typos
  shopt -s checkwinsize            # Update windows size on command
  shopt -s histappend              # Append History instead of overwriting file
  shopt -s cmdhist                 # Bash attempts to save all lines of a multiple-line command in the same history entry
  shopt -s extglob                 # Extended pattern
  shopt -s no_empty_cmd_completion # No empty completion
  # COMPLETION {{{
    complete -cf sudo
    if [[ -f /etc/bash_completion ]]; then
      source /etc/bash_completion
    fi
  #}}}
#}}}
# PS1 CONFIG {{{

B='\[\e[1;38;5;33m\]'
LB='\[\e[1;38;5;81m\]'
GY='\[\e[1;38;5;242m\]'
G='\[\e[1;38;5;82m\]'
P='\[\e[1;38;5;161m\]'
PP='\[\e[1;38;5;93m\]'
R='\[\e[1;38;5;196m\]'
Y='\[\e[1;38;5;214m\]'
W='\[\e[0m\]'

get_prompt_symbol() {
    [[ $UID == 0 ]] && echo "#" || echo "\$"
}

export PS1="$GY[$Y\u$GY@$P\h$GY:$B\w$GY]$W\$(__git_ps1) \$(get_prompt_symbol) "
#}}}
# CONFIG {{{
  export PATH=/usr/local/bin:$PATH
  if [[ -d "$HOME/bin" ]] ; then
      PATH="$HOME/bin:$PATH"
  fi
  # ANDROID SDK {{{
    if [[ -d "/opt/android-sdk" ]]; then
          export ANDROID_HOME=/opt/android-sdk
    fi
  #}}}
  # EDITOR {{{
    if which vim &>/dev/null; then
      export EDITOR="vim"
    elif which emacs &>/dev/null; then
      export EDITOR="emacs -nw"
    else
      export EDITOR="nano"
    fi
  #}}}
  # BASH HISTORY {{{
    # make multiple shells share the same history file
    export HISTSIZE=1000            # bash history will save N commands
    export HISTFILESIZE=${HISTSIZE} # bash will remember N commands
    export HISTCONTROL=ignoreboth   # ingore duplicates and spaces
    export HISTIGNORE='&:ls:ll:la:cd:exit:clear:history'
  #}}}
  # COLORED MANUAL PAGES {{{
    # @see http://www.tuxarena.com/?p=508
    # For colourful man pages (CLUG-Wiki style)
    if $_isxrunning; then
      export PAGER=less
      export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
      export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
      export LESS_TERMCAP_me=$'\E[0m'           # end mode
      export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
      export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
      export LESS_TERMCAP_ue=$'\E[0m'           # end underline
      export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline
    fi
  #}}}
#}}}
# ALIAS {{{
  alias freemem='sudo /sbin/sysctl -w vm.drop_caches=3'
  alias enter_matrix='echo -e "\e[32m"; while :; do for i in {1..16}; do r="$(($RANDOM % 2))"; if [[ $(($RANDOM % 5)) == 1 ]]; then if [[ $(($RANDOM % 4)) == 1 ]]; then v+="\e[1m $r   "; else v+="\e[2m $r   "; fi; else v+="     "; fi; done; echo -e "$v"; v=""; done'
  # GIT_OR_HUB {{{
    if which hub &>/dev/null; then
      alias git=hub
    fi
  #}}}
  # AUTOCOLOR {{{
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
  #}}}
  # MODIFIED COMMANDS {{{
    alias ..='cd ..'
    alias ...='cd ../..'
    alias df='df -h'
    alias diff='colordiff'              # requires colordiff package
    alias du='du -c -h'
    alias free='free -m'                # show sizes in MB
    alias grep='grep --color=auto'
    alias grep='grep --color=tty -d skip'
    alias mkdir='mkdir -p -v'
    alias more='less'
    alias nano='nano -w'
    alias ping='ping -c 5'
  #}}}
  # PRIVILEGED ACCESS {{{
    if ! $_isroot; then
      alias sudo='sudo '
      alias scat='sudo cat'
      alias svim='sudo vim'
      alias root='sudo su'
      alias reboot='sudo reboot'
      alias halt='sudo halt'
    fi
  #}}}
  # LS {{{
    alias ls='ls -hF --color=auto'
    alias lr='ls -R'                    # recursive ls
    alias ll='ls -alh'
    alias la='ll -A'
    alias lm='la | less'
  #}}}
#}}}
# FUNCTIONS {{{
    # ARCHIVE EXTRACTOR {{{
    extract() {
        clrstart="\033[1;34m"  #color codes
        clrend="\033[0m"

        if [[ "$#" -lt 1 ]]; then
        echo -e "${clrstart}Pass a filename. Optionally a destination folder. You can also append a v for verbose output.${clrend}"
        exit 1 #not enough args
        fi

        if [[ ! -e "$1" ]]; then
        echo -e "${clrstart}File does not exist!${clrend}"
        exit 2 #file not found
        fi

        if [[ -z "$2" ]]; then
        DESTDIR="." #set destdir to current dir
        elif [[ ! -d "$2" ]]; then
        echo -e -n "${clrstart}Destination folder doesn't exist or isnt a directory. Create? (y/n): ${clrend}"
        read response
        #echo -e "\n"
        if [[ $response == y || $response == Y ]]; then
            mkdir -p "$2"
            if [ $? -eq 0 ]; then
            DESTDIR="$2"
            else
            exit 6 #Write perms error
            fi
        else
            echo -e "${clrstart}Closing.${clrend}"; exit 3 # n/wrong response
        fi
        else
        DESTDIR="$2"
        fi

        if [[ ! -z "$3" ]]; then
        if [[ "$3" != "v" ]]; then
            echo -e "${clrstart}Wrong argument $3 !${clrend}"
            exit 4 #wrong arg 3
        fi
        fi

        filename=`basename "$1"`

        #echo "${filename##*.}" debug

        case "${filename##*.}" in
        tar)
            echo -e "${clrstart}Extracting $1 to $DESTDIR: (uncompressed tar)${clrend}"
            tar x${3}f "$1" -C "$DESTDIR"
            ;;
        gz)
            echo -e "${clrstart}Extracting $1 to $DESTDIR: (gip compressed tar)${clrend}"
            tar x${3}fz "$1" -C "$DESTDIR"
            ;;
        tgz)
            echo -e "${clrstart}Extracting $1 to $DESTDIR: (gip compressed tar)${clrend}"
            tar x${3}fz "$1" -C "$DESTDIR"
            ;;
        xz)
            echo -e "${clrstart}Extracting  $1 to $DESTDIR: (gip compressed tar)${clrend}"
            tar x${3}f -J "$1" -C "$DESTDIR"
            ;;
        bz2)
            echo -e "${clrstart}Extracting $1 to $DESTDIR: (bzip compressed tar)${clrend}"
            tar x${3}fj "$1" -C "$DESTDIR"
                    ;;
        zip)
            echo -e "${clrstart}Extracting $1 to $DESTDIR: (zipp compressed file)${clrend}"
            unzip "$1" -d "$DESTDIR"
            ;;
        rar)
            echo -e "${clrstart}Extracting $1 to $DESTDIR: (rar compressed file)${clrend}"
            unrar x "$1" "$DESTDIR"
            ;;
        7z)
            echo -e  "${clrstart}Extracting $1 to $DESTDIR: (7zip compressed file)${clrend}"
            7za e "$1" -o"$DESTDIR"
            ;;
        *)
            echo -e "${clrstart}Unknown archieve format!"
            exit 5
            ;;
        esac
    }
    #}}}
    # ARCHIVE COMPRESS {{{
    compress() {
        if [[ -n "$1" ]]; then
        FILE=$1
        case $FILE in
        *.tar ) shift && tar cf $FILE $* ;;
    *.tar.bz2 ) shift && tar cjf $FILE $* ;;
        *.tar.gz ) shift && tar czf $FILE $* ;;
        *.gz ) shift && gzip -c $* > $FILE ;;
        *.tgz ) shift && tar czf $FILE $* ;;
        *.zip ) shift && zip $FILE $* ;;
        *.rar ) shift && rar $FILE $* ;;
        esac
        else
        echo "usage: compress <foo.tar.gz> ./foo ./bar"
        fi
    }
    #}}}
    # SIMPLE CALCULATOR #{{{
    # usage: calc <equation>
    calc() {
        if which bc &>/dev/null; then
        echo "scale=3; $*" | bc -l
        else
        awk "BEGIN { print $* }"
        fi
    }
    #}}}
    ## FIND A FILE WITH A PATTERN IN NAME {{{
        ff() { find . -type f -iname '*'$*'*' -ls ; }
    #}}}
    ## FIND A FILE WITH PATTERN $1 IN NAME AND EXECUTE $2 ON IT {{{
        fe() { find . -type f -iname '*'$1'*' -exec "${2:-file}" {} \;  ; }
    #}}}
    ## FINDS DIRECTORY SIZES AND LISTS THEM FOR THE CURRENT DIRECTORY {{{
        dirsize () {
		du -shx * .[a-zA-Z0-9_]* 2> /dev/null | egrep '^ *[0-9.]*[MG]' | sort -n > /tmp/list
		egrep '^ *[0-9.]*M' /tmp/list
		egrep '^ *[0-9.]*G' /tmp/list
		rm -rf /tmp/list
        }
    #}}}
    ## GREP FUNCTIONS FOR LAZY BOIS AS ME {{{
	gri() { grep -ri --exclude=\*.json --exclude=jquery\*.js --exclude=node_modules/* --exclude=*.min.* "$1" * ; }
	gr() { grep -r --exclude=\*.json --exclude=jquery\*.js --exclude=node_modules/* --exclude=*.min.* "$1" * ; }
    #}}}
    ## Extra alias, import from .alias.d directory {{{
    if [ -d ~/.alias.d ]; then for f in ~/.alias.d/*; do source $f; done; fi
    #}}}
#}}}
