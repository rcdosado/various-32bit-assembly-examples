@echo off
cls
..\tasm32.exe -ml -t -q -m5 -q  req21.asm
..\tlink32 req21,,,..\import32.lib+..\imsvcrt.lib,,
del req21.map
del req21.obj
