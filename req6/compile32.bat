@echo off
cls
..\ml.exe /c /coff /Zi rec6.asm
..\link rec6.obj /SUBSYSTEM:CONSOLE /IGNORE:4108 
del rec6.obj
