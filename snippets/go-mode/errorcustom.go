# -*- mode: snippet -*-
# name: if error custom
# key: /ec
# --
if ${1:err} != nil {
   ${2:PRINT_FUNC}("${3:CONTEXT} err:", err)
}$0