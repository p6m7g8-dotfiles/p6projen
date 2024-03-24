# shellcheck shell=bash
######################################################################
#<
#
# Function: p6df::modules::p6projen::deps()
#
#>
######################################################################
p6df::modules::p6projen::deps() {
  ModuleDeps=(
    p6m7g8-dotfiles/p6common
  )
}

######################################################################
#<
#
# Function: p6df::modules::p6projen::init(_module, dir)
#
#  Args:
#	_module -
#	dir -
#
#>
######################################################################
p6df::modules::p6projen::init() {
  local _module="$1"
  local dir="$2"

  p6_bootstrap "$dir"

  p6_return_void
}
