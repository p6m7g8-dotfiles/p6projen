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
#>
######################################################################
p6df::modules::p6projen::init() {

  p6_bootstrap "$__p6_dir"
}
