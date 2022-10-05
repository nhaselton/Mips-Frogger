from pathlib import Path

src = ""
cCount = 0
hCount = 0

pathlist = Path(src).rglob('*.asm')
for path in pathlist:
     # because path is object not string
    path_in_str = str(path)
    if("lib" not in path_in_str):
        lines = sum(1 for line in open(path))
        cCount+= lines;
        print(str(path) + ": " + str(lines))


print("\n\n\n");
print("lines: " + str(cCount))
