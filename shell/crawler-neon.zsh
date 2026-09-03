# Crawler Neon prompt for plain zsh: no oh-my-posh, no oh-my-zsh, no Nerd Font.
#
#   source /path/to/crawler-neon-theme/shell/crawler-neon.zsh   # in ~/.zshrc
#
# Shows the last two path segments in gold, the git branch in magenta with a
# yellow * for unstaged and a green + for staged changes, the active Python
# virtualenv in aqua, and a purple ❯ that turns into a red ✗ after a failing
# command. The right side shows how long the last command took when it was
# slow. Terminals without truecolor (Apple Terminal) get the nearest of the
# 256 standard colours.

[[ $COLORTERM == (24bit|truecolor) ]] || zmodload zsh/nearcolor 2>/dev/null
zmodload zsh/datetime

typeset -gA CRAWLER_NEON=(
  gold    '#FAC234'   magenta '#FB03D6'   red    '#FA2120'   yellow '#F3FB04'
  green   '#02FB03'   orange  '#FC7E03'   aqua   '#03FBC7'   purple '#B455F0'
  soft    '#B9AEB4'
)

autoload -Uz vcs_info add-zsh-hook
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr   "%F{$CRAWLER_NEON[green]}+"
zstyle ':vcs_info:git:*' unstagedstr "%F{$CRAWLER_NEON[yellow]}*"
zstyle ':vcs_info:git:*' formats       " %F{$CRAWLER_NEON[magenta]}%b%c%u%f"
zstyle ':vcs_info:git:*' actionformats " %F{$CRAWLER_NEON[magenta]}%b%F{$CRAWLER_NEON[red]}|%a%c%u%f"

# Timing: remember when a command started, report it if it ran two seconds or more.
crawler_neon_preexec() { CRAWLER_NEON_STARTED=$EPOCHREALTIME }
crawler_neon_precmd() {
  vcs_info
  CRAWLER_NEON_ELAPSED=''
  if [[ -n $CRAWLER_NEON_STARTED ]]; then
    local -F seconds=$(( EPOCHREALTIME - CRAWLER_NEON_STARTED ))
    (( seconds >= 2 )) && CRAWLER_NEON_ELAPSED=$(printf '%.1fs' $seconds)
    unset CRAWLER_NEON_STARTED
  fi
}
add-zsh-hook preexec crawler_neon_preexec
add-zsh-hook precmd  crawler_neon_precmd

crawler_neon_venv() { [[ -n $VIRTUAL_ENV ]] && print -n " %F{$CRAWLER_NEON[aqua]}${VIRTUAL_ENV:t}%f" }

setopt PROMPT_SUBST
PROMPT='%F{$CRAWLER_NEON[gold]}%2~%f${vcs_info_msg_0_}$(crawler_neon_venv) %(?.%F{$CRAWLER_NEON[purple]}❯.%F{$CRAWLER_NEON[red]}✗)%f '
RPROMPT='%F{$CRAWLER_NEON[soft]}${CRAWLER_NEON_ELAPSED}%f'
