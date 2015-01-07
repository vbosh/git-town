#!/usr/bin/env bash

# Helper methods for dealing with configuration.

# Add a new non-feature branch if possible, and show confirmation
function add_non_feature_branch {
  local branch_name=$1

  ensure_has_branch "$branch_name"
  if [ "$(is_non_feature_branch "$branch_name")" == true ]; then
    echo "'$branch_name' is already a non-feature branch"
  else
    local new_branches=$(insert_string "$non_feature_branch_names" ',' "$branch_name")
    store_configuration non-feature-branch-names "$new_branches"
    echo "Added '$branch_name' as a non-feature branch"
  fi
}

# Add or remove non-feature branch if possible, and show confirmation
function add_or_remove_non_feature_branches {
  local operation=$1
  local branch_name=$2

  if [ -z "$branch_name" ]; then
    if [ "$operation" == "--add" ] || [ "$operation" == "--remove" ]; then
      echo "Missing branch name"
    fi
    echo "usage: git town non-feature-branches (--add | --remove) <branchname>"
  else
    if [ "$operation" == "--add" ]; then
      add_non_feature_branch "$branch_name"
    elif [ "$operation" == "--remove" ]; then
      remove_non_feature_branch "$branch_name"
    else
      echo "usage: git town non-feature-branches (--add | --remove) <branchname>"
    fi
  fi
}


# Returns git-town configuration
function get_configuration {
  local config_setting_name=$1
  git config "git-town.$config_setting_name"
}


# Remove a non-feature branch if possible, and show confirmation
function remove_non_feature_branch {
  local branch_name=$1

  if [ "$(is_non_feature_branch "$branch_name")" == true ]; then
    local new_branches=$(remove_string "$non_feature_branch_names" ',' "$branch_name")
    store_configuration non-feature-branch-names "$new_branches"
    echo "Removed '$branch_name' from non-feature branches"
  else
    echo "'$branch_name' is not a non-feature branch"
  fi
}


function show_config {
  show_main_branch
  show_non_feature_branches
}


function show_main_branch {
  echo "Main branch: $(value_or_none "$main_branch_name")"
}


function show_non_feature_branches {
  echo "Non-feature branches: $(value_or_none "$non_feature_branch_names")"
}


function show_or_update_main_branch {
  local branch_name=$1
  if [ -n "$branch_name" ]; then
    ensure_has_branch "$branch_name"
    store_main_branch_name_with_confirmation_text "$branch_name"
  else
    show_main_branch
  fi
}


function show_or_update_non_feature_branches {
  local operation=$1
  local branch_name=$2
  if [ -n "$operation" ]; then
    add_or_remove_non_feature_branches "$operation" "$branch_name"
  else
    show_non_feature_branches
  fi
}


# Persists git-town configuration
function store_configuration {
  local config_setting_name=$1
  local value=$2
  git config "git-town.$config_setting_name" "$value"
}


# Persists the main branch configuration
function store_main_branch_name_with_confirmation_text {
  store_configuration main-branch-name "$1"
  echo "main branch stored as '$1'"
}


# Persists the non-feature branch configuration
function store_non_feature_branch_names_with_confirmation_text {
  store_configuration non-feature-branch-names "$1"
  echo "non-feature branches stored as '$1'"
}


function value_or_none {
  if [ -z "$1" ]; then
    echo "[none]"
  else
    echo "$1"
  fi
}


function ensure_main_branch_configured {
  # Update old configuration to new one if it exists
  if [[ -f ".main_branch_name" ]]; then
    store_configuration main-branch-name "$(cat .main_branch_name)"
    rm .main_branch_name
  fi

  local main_branch_name=$(get_configuration main-branch-name)

  if [[ -z "$main_branch_name" ]]; then
    echo "Please enter the name of the main branch (typically 'master' or 'development'):"
    read main_branch_name
    if [[ -z "$main_branch_name" ]]; then
      echo_error_header
      echo_error "You have not provided the name for the main branch."
      echo_error "This information is necessary to run this script."
      echo_error "Please try again."
      exit_with_error
    fi
    echo
    store_main_branch_name_with_confirmation_text "$main_branch_name"
  fi
}


function ensure_non_feature_branches_configured {
  local non_feature_branch_names=$(get_configuration non-feature-branch-names)

  if [[ $? == '1' ]]; then
    echo
    echo "Git Town supports non-feature branches like 'release' or 'production'."
    echo "These branches cannot be shipped and do not merge $main_branch_name when syncing."
    echo "Please enter the names of all your non-feature branches as a comma separated list."
    echo "Example: 'qa, production'"
    read non_feature_branch_names
    echo
    store_non_feature_branch_names_with_confirmation_text "$non_feature_branch_names"
  fi
}
