# -*- mode: snippet -*-
# name: Error panic
# key: /ep
# --
if ${1:err} != nil {
	panic(fmt.Sprintf("${3:CONTEXT} err: %s", err))
}$0
