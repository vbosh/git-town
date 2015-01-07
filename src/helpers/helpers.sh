#!/usr/bin/env bash
# Note: "set -e" causes failures here

current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export program="$(echo "$0" | grep -o "[^/]*$")"
export git_command="${program/-/ }"

source "$current_dir/git_helpers/branch_helpers.sh"
source "$current_dir/git_helpers/checkout_helpers.sh"
source "$current_dir/git_helpers/cherry_pick_helpers.sh"
source "$current_dir/git_helpers/commits_helpers.sh"
source "$current_dir/git_helpers/conflict_helpers.sh"
source "$current_dir/git_helpers/fetch_helpers.sh"
source "$current_dir/git_helpers/feature_branch_helpers.sh"
source "$current_dir/git_helpers/merge_helpers.sh"
source "$current_dir/git_helpers/open_changes_helpers.sh"
source "$current_dir/git_helpers/push_helpers.sh"
source "$current_dir/git_helpers/rebase_helpers.sh"
source "$current_dir/git_helpers/remote_helpers.sh"
source "$current_dir/git_helpers/sha_helpers.sh"
source "$current_dir/git_helpers/shippable_changes_helpers.sh"
source "$current_dir/git_helpers/tracking_branch_helpers.sh"

source "$current_dir/browser_helpers.sh"
source "$current_dir/configuration.sh"
source "$current_dir/file_helpers.sh"
source "$current_dir/script_helpers.sh"
source "$current_dir/string_helpers.sh"
source "$current_dir/terminal_helpers.sh"
source "$current_dir/tool_helpers.sh"
source "$current_dir/undo_helpers.sh"

if [[ $1 != "--bypass-automatic-configuration" ]]; then
  ensure_main_branch_configured
  ensure_non_feature_branches_configured
fi

export main_branch_name=$(get_configuration main-branch-name)
export non_feature_branch_names=$(get_configuration non-feature-branch-names)

export initial_branch_name=$(get_current_branch_name)
export initial_open_changes=$(has_open_changes)
