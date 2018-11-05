# -*- mode: snippet -*-
# name: errlogfatal
# key: /elf
# --
if ${1:err} != nil {
	log.Fatal("${3:CONTEXT} err:", err)
}$0