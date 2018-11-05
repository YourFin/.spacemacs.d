# -*- mode: snippet -*-
# name: errLogPrint
# key: /elp
# --
if ${1:err} != nil {
	log.Println("${3:CONTEXT} err:", err)
}
$0
