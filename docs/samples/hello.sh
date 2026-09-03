#!/usr/bin/env bash
# Greetings in a few languages, with enough Bash in it to show a colour theme.
set -euo pipefail

readonly DEFAULT_TARGET="World"
readonly MAX_WIDTH=42
declare -a GREETINGS=("en:Hello, %s!" "el:Γεια σου, %s!" "fr:Bonjour, %s !")
declare -i count=0

# render <template> <target>: expand the template with the target
render() {
    local template="$1" target="$2"
    printf "$template" "$target"
}

# greet <target>: print every greeting, numbered, and fail on over-long lines
greet() {
    local target="${1:-$DEFAULT_TARGET}"
    local entry language template line
    for entry in "${GREETINGS[@]}"; do
        language="${entry%%:*}"
        template="${entry#*:}"
        line="$(render "$template" "$target")"
        if (( ${#line} > MAX_WIDTH )); then
            echo "error: '$language' greeting exceeds $MAX_WIDTH characters" >&2
            return 1
        fi
        count+=1
        printf '%2d. %s\n' "$count" "$line"
    done
}

main() {
    case "${1:-}" in
        -h|--help) echo "usage: $(basename "$0") [target]"; return 0 ;;
    esac
    greet "$@"
    echo "-- $count greetings in ${#GREETINGS[@]} languages"
}

main "$@"
