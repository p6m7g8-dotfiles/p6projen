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
# Function: p6df::modules::p6projen::init(module, dir)
#
#  Args:
#	module -
#	dir -
#
#>
######################################################################
p6df::modules::p6projen::init() {
  local module="$1"
  local dir="$2"

  p6_bootstrap "$dir"
}
