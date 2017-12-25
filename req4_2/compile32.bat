@echo off
cls
..\tasm32.exe -ml -t -q -m5 -q  rec42.asm
..\tlink32 rec42,,,..\import32.lib+..\imsvcrt.lib,,
del rec42.map
del rec42.obj
