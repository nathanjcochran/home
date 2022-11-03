# ls aliases
alias ll='LC_COLLATE=C ls -AlhXF --g'
alias la='LC_COLLATE=C ls -A'
alias l='LC_COLLATE=C ls -CF'
alias l1='LC_COLLATE=C ls -1XF --g'

# other aliases
alias j='jobs'
alias kj='kill $(jobs -p)'
alias postman='postman &> /dev/null'
alias dc='docker-compose'
alias grepr='grep -Rn --exclude-dir=".git" --exclude-dir="vendor" --exclude-dir="node_modules"'
alias grepgo='grep -Rn --exclude-dir=".git" --exclude-dir="vendor"'
alias grepjs='grep -Rn --exclude-dir=".git" --exclude-dir="node_modules" --exclude-dir="build" --exclude-dir="cache" --exclude-dir="dist" --exclude="*-lock.*" --exclude-dir="release" --exclude-dir="ts-dist" --exclude="*.prod.js*" --exclude="*.dev.js*" --exclude="*.js.map" --exclude="*.tsbuildinfo"'
alias todo='grepr TODO'
alias todiff='git diff dev -S "TODO:" --name-only'
alias treer='tree -a -I vendor'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# git branch delete squashed
alias gbds='git fetch -p && git branch -D $(git branch -vv | grep ": gone]" | awk "{print \$1}")'
# git branch list squashed
alias gbls='git fetch -p && git branch -vv | grep ": gone]" | awk "{print \$1}"'

# Terraform
alias tf='terraform'
