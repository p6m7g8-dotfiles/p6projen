######################################################################
#<
#
# Function: p6df::modules::p6projen::deps()
#
#  Depends:	 p6_bootstrap
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
# Function: p6df::modules::p6projen::init()
#
#  Depends:	 p6_bootstrap
#  Environment:	 P6_DFZ_SRC_P6M7G8_DIR
#>
######################################################################
p6df::modules::p6projen::init() {
  local dir="$1"

  p6_bootstrap "$dir"
}
