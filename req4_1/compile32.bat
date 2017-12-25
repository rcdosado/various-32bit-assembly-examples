..\tasm32.exe -ml -t -q -m5 -q  rec41.asm
..\tlink32 rec41,,,..\import32.lib+..\imsvcrt.lib,,
del rec41.map
del rec41.obj
