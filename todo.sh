#!/bin/bash

# Lol TODO:
# [ ] Max depth arg/ENV_VAR
# [ ] Better USAGE


set -euo pipefail

TODO_FILENAME=${TODO_FILENAME:-"todo.md"}

USAGE="$(basename $0) [/path/to/look/for/todo/in]

Looks for a file named $TODO_FILENAME in current or parent-to-current directories.
"

if [[ ! ${1+"x"} ]]; then
  search_dir="$PWD"
else 
  search_dir="$1"
fi

if [[ "$search_dir" == "-h" ]] || [[ "$search_dir" == "--help" ]]; then
  echo "$USAGE"
  exit 1
fi

if [[ ! -d "$search_dir" ]]; then
  echo "$search_dir is not a fucking directory you dumb asshole!"
  exit 1
fi

while [[ ! "$search_dir" == "/" ]]; do 
  if [[ -f "$search_dir/todo.md" ]]; then
    ${EDITOR} ${search_dir}/todo.md
    exit $?
  fi
  search_dir="$(dirname "$search_dir")"
done

read -p "No todo found. Would you like to start one? [Y/n]: " answer
answer="${answer,,}"
if [[ "$answer" == "y" ]]; then
  read -p "Where would you like to make todo.md? ($PWD): " where
  where="${where:-$PWD}/todo.md"
  echo "Making $where and opening it for editing" 
  touch "$where"
  ${EDITOR} ${where}
  exit $?
elif [[ "$answer" == "n" ]]; then
  echo "ok then..."
else
  echo "Ya aint makin no sense!"
fi

