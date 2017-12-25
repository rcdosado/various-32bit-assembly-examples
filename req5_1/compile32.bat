@echo off
cls
..\tasm32.exe -ml -t -q -m5 -q  rec51.asm
..\tlink32 rec51,,,..\import32.lib+..\imsvcrt.lib,,
del rec51.map
del rec51.obj
