# .bashrc
# by amg1893
# Help from helmuthdu <3
  shopt -s cdspell                 # Correct cd typos
  shopt -s checkwinsize            # Update windows size on command
  shopt -s histappend              # Append History instead of overwriting file
  shopt -s cmdhist                 # Bash attempts to save all lines of a multiple-line command in the same history entry
  shopt -s extglob                 # Extended pattern
  shopt -s no_empty_cmd_completion # No empty completion
    complete -cf sudo
    if [[ -f /etc/bash_completion ]]; then
      source /etc/bash_completion
    fi

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

if [ -f /usr/lib/bash-git-prompt/gitprompt.sh ]; then
    # To only show the git prompt in or under a repository directory
    # GIT_PROMPT_ONLY_IN_REPO=1
    # To use upstream's default theme
    # GIT_PROMPT_THEME=Default
    # To use upstream's default theme, modified by arch maintainer
    # GIT_PROMPT_THEME=Default_Arch
    GIT_PROMPT_THEME=Single_line
    source /usr/lib/bash-git-prompt/gitprompt.sh
fi

# CONFIG
if [[ -d "$HOME/bin" ]] ; then
    PATH="$HOME/bin:$PATH"
fi
if [[ -d "$HOME/.local/share/umake/bin" ]] ; then
    PATH="$PATH:$HOME/.local/share/umake/bin"
fi
if [[ -d "$HOME/.composer/vendor/bin" ]] ; then
    PATH="$PATH:$HOME/.composer/vendor/bin"
fi
if [[ -d "$HOME/.yarn/bin" ]] ; then
    PATH="$PATH:$HOME/.yarn/bin"
fi

# ANDROID SDK
if [[ -d "/opt/android-sdk" ]]; then
      export ANDROID_HOME=/opt/android-sdk
fi

# EDITOR
if which vim &>/dev/null; then
  export EDITOR="vim"
fi

# BASH HISTORY
# make multiple shells share the same history file
export HISTSIZE=1000            # bash history will save N commands
export HISTFILESIZE=${HISTSIZE} # bash will remember N commands
export HISTCONTROL=ignoreboth   # ingore duplicates and spaces
export HISTIGNORE='&:ls:ll:la:cd:exit:clear:history'

if [ -d ~/.alias.d ]; then for f in ~/.alias.d/*; do source $f; done; fi

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

calc() {
  if which bc &>/dev/null; then
    echo "scale=3; $*" | bc -l
  else
    awk "BEGIN { print $* }"
  fi
}
ff() { find . -type f -iname '*'$*'*' -ls ; }

fe() { find . -type f -iname '*'$1'*' -exec "${2:-file}" {} \;  ; }

dirsize () {
  du -shx * .[a-zA-Z0-9_]* 2> /dev/null | egrep '^ *[0-9.]*[MG]' | sort -n > /tmp/list
  egrep '^ *[0-9.]*M' /tmp/list
  egrep '^ *[0-9.]*G' /tmp/list
  rm -rf /tmp/list
}

gri() { grep -ri --exclude=\*.json --exclude=jquery\*.js --exclude=node_modules/* --exclude=*.min.* "$1" * ; }
gr() { grep -r --exclude=\*.json --exclude=jquery\*.js --exclude=node_modules/* --exclude=*.min.* "$1" * ; }