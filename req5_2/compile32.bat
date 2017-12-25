@echo off
cls
..\tasm32.exe -ml -t -q -m5 -q  rec52.asm
..\tlink32 rec52,,,..\import32.lib+..\imsvcrt.lib,,
del rec52.map
del rec52.obj
