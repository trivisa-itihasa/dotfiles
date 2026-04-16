#!/usr/bin/env bash
set -ueo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
DOTDIR="$(dirname "$SCRIPT_DIR")"
BACKUP_DIR="$HOME/.dotbackup"
STRUCTURE_FILE="$SCRIPT_DIR/structure.map"

helpmsg() {
  command echo "Usage: $0 [--help | -h] [--debug | -d]" >&2
}

backup_and_link() {
  local src="$1"
  local dest="$2"
  local dest_dir
  dest_dir="$(dirname "$dest")"

  # Create parent directory if needed
  [[ -d "$dest_dir" ]] || mkdir -p "$dest_dir"

  # Remove existing symlink
  if [[ -L "$dest" ]]; then
    command rm -f "$dest"
  fi

  # Backup existing file/directory
  if [[ -e "$dest" ]]; then
    local backup_dest="$BACKUP_DIR/${dest#$HOME/}"
    mkdir -p "$(dirname "$backup_dest")"
    command mv "$dest" "$backup_dest"
    command echo "  backed up: $dest -> $backup_dest"
  fi

  command ln -snf "$src" "$dest"
  command echo "  linked: $src -> $dest"
}

install() {
  if [[ "$HOME" == "$DOTDIR" ]]; then
    command echo "Error: dotfiles directory is the same as HOME" >&2
    exit 1
  fi

  command echo "Installing dotfiles..."
  mkdir -p "$BACKUP_DIR"

  while IFS= read -r line || [[ -n "$line" ]]; do
    # Skip comments and empty lines
    [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue

    # Parse "source -> target" format
    local src target
    src="$(echo "$line" | sed 's/[[:space:]]*->.*$//')"
    target="$(echo "$line" | sed 's/^.*->[[:space:]]*//')"

    # Trim whitespace
    src="$(echo "$src" | xargs)"
    target="$(echo "$target" | xargs)"

    [[ -z "$src" || -z "$target" ]] && continue

    backup_and_link "$DOTDIR/$src" "$HOME/$target"
  done < "$STRUCTURE_FILE"

  printf '\e[1;36m Install completed! \e[m\n'
}

while [[ $# -gt 0 ]]; do
  case ${1} in
  --debug | -d)
    set -uex
    ;;
  --help | -h)
    helpmsg
    exit 1
    ;;
  *) ;;
  esac
  shift
done

install
