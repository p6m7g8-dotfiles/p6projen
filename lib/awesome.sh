# shellcheck shell=bash

######################################################################
#<
#
# Function: words projects = p6_projen_awesome_collect()
#
#  Returns:
#	words - projects
#
#  Environment:	 P6_DFZ_SRC_P6M7G8_DOTFILES_DIR
#>
######################################################################
p6_projen_awesome_collect() {

    local projects
    projects=$(p6_file_display "$P6_DFZ_SRC_P6M7G8_DOTFILES_DIR/p6projen/conf/projects" | sort -r)

    p6_return_words "$projects"
}

######################################################################
#<
#
# Function: p6_projen_awesome_clones([parallel=8])
#
#  Args:
#	OPTIONAL parallel - [8]
#
#  Environment:	 P6_DFZ_SRC_FOCUSED_DIR
#>
######################################################################
p6_projen_awesome_clones() {
    local parallel="${1:-8}"

    local dir="$P6_DFZ_SRC_FOCUSED_DIR/projens"
    p6_dir_mk "$dir"

    local projects=$(p6_projen_awesome_collect)

    p6_run_parallel "0" "$parallel" "$projects" "p6_github_cli_clone" "" "$dir"
}

######################################################################
#<
#
# Function: p6_projen_awesome_foreach(code, dir, code, project)
#
#  Args:
#	code -
#	dir -
#	code -
#	project -
#
#  Environment:	 P6_DFZ_DATA_DIR
#>
######################################################################
p6_projen_awesome_foreach() {
    local code="$1"

    local projects=$(p6_projen_awesome_collect)
    local dir="$P6_DFZ_DATA_DIR/src/github.com/projens"

    p6_run_parallel "0" "50" "$projects" "do_it" "$dir" "$code" >/dev/null
}

do_it() {
    local dir="$1"
    local code="$2"
    local project="$3"

    (
        cd "$dir/$project" || exit 1
        p6_run_code "$code" "$project"
    ) >&2
}

######################################################################
#<
#
# Function: p6_projen_awesome_version()
#
#>
######################################################################
p6_projen_awesome_version() {

    if p6_node_yarn_is; then
        grep "^projen@" yarn.lock
    elif p6_node_npm_is; then
        grep "^projen@" package-lock.json | head -1
    else
        p6_echo "idk"
    fi
}

######################################################################
#<
#
# Function: p6_projen_awesome_cdk_version()
#
#>
######################################################################
p6_projen_awesome_cdk_version() {

    grep cdkVersion .projenrc.js
}

######################################################################
#<
#
# Function: p6_projen_awesome_pkg()
#
#>
######################################################################
p6_projen_awesome_pkg() {

    if p6_node_yarn_is; then
        p6_echo "yarn"
    elif p6_node_npm_is; then
        p6_echo "npm"
    else
        p6_echo "idk"
    fi
}

######################################################################
#<
#
# Function: p6_projen_awesome_type()
#
#>
######################################################################
p6_projen_awesome_type() {

    grep -o "new .*({" .projenrc.js | awk '{print $2}' | sed -e 's/({//'
}

######################################################################
#<
#
# Function: p6_projen_awesome_branch()
#
#>
######################################################################
p6_projen_awesome_branch() {

    grep defaultReleaseBranch: .projenrc.js | sed -e 's/.*://'
}

######################################################################
#<
#
# Function: p6_projen_awesome_module()
#
#>
######################################################################
p6_projen_awesome_module() {

    grep -o "@aws-cdk/aws-[^'\",@]*" .projenrc.js
}

######################################################################
#<
#
# Function: p6_projen_awesome_update()
#
#>
######################################################################
p6_projen_awesome_update() {

    p6_h1 "$(pwd)"

    p6_git_p6_reset_head_hard
    p6_git_p6_checkout_default
    yarn install && \
	npx projen projen:upgrade && \
	npx projen build && {
	  p6_git_p6_status
          p6_git_p6_diff
          p6_git_p6_add_all
          p6_projen_awesome_submit
        }

    p6_return_void
}

######################################################################
#<
#
# Function: p6_projen_awesome_pr()
#
#>
######################################################################
p6_projen_awesome_pr() {

    gh pr list -s all --limit 600 | wc -l
}

######################################################################
#<
#
# Function: p6_projen_awesome_description(project)
#
#  Args:
#	project -
#
#>
######################################################################
p6_projen_awesome_description() {
    local project="$1"

    {
        echo "- [$project](https://github.com/$project/main/.projectrc.js) - "
        echo "%%%%"
        grep description .projenrc.js | head -1 | sed -e 's/.*description://' | grep -v undefined
        echo "%%%%"
        echo "."
    } | xargs
}

######################################################################
#<
#
# Function: p6_projen_awesome_diff()
#
#>
######################################################################
p6_projen_awesome_diff() {

    p6_git_p6_diff
}

######################################################################
#<
#
# Function: p6_projen_awesome_synthesize()
#
#>
######################################################################
p6_projen_awesome_synthesize() {

    npx projen
}

######################################################################
#<
#
# Function: p6_projen_awesome_build()
#
#>
######################################################################
p6_projen_awesome_build() {

    npx projen build
}

######################################################################
#<
#
# Function: p6_projen_awesome_upgrade()
#
#>
######################################################################
p6_projen_awesome_upgrade() {

    npx projen projen:upgrade
}

######################################################################
#<
#
# Function: p6_projen_awesome_submit()
#
#>
######################################################################
p6_projen_awesome_submit() {

    local before
    before=$(p6_git_p6_diff package.json | grep '"projen":' | awk '{ print $3 }' | sed -e 's,[^^0-9.],,g' | head -1)
    local after
    after=$(p6_git_p6_diff package.json | grep '"projen":' | awk '{ print $3 }' | sed -e 's,[^^0-9.],,g' | tail -1)

    p6_git_p6_add_all
    p6_github_gh_pr_submit "chore(deps): bumps projen from $before to $after"
}

######################################################################
#<
#
# Function: p6__pad(str, length)
#
#  Args:
#	str -
#	length -
#
#  Environment:	 MP6
#>
######################################################################
p6__pad() {
    local str="$1"
    local length="$2"

    perl -MP6::Util -e "print P6::Util::rprint($length, \"$str\")"
}
