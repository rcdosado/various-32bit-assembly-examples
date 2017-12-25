@echo off
tasm.exe /m5 rec7.asm
tlink /t rec7.obj
pause
del rec7.obj
del rec7.map