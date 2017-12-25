@echo off
cls
..\tasm32.exe -ml -t -q -m5 -q rec22.asm
..\tlink32 rec22,,,..\import32.lib+..\imsvcrt.lib,,
del rec22.map
del rec22.obj
