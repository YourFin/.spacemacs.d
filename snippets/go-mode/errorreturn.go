# -*- mode: snippet -*-
# name: Error return
# key: /er
# --
if ${1:err} != nil {
	return $1$2
}$0
