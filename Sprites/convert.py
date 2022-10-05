import sys
from PIL import Image

path = sys.argv[1]
im = Image.open(path) 

index = path.rfind('.');
path = path[:index]
path += ".sprite"

def writeNum (string,file):
    string = str(string)
    l = len(string)
    final = ""
    for i in range(8-l):
        final +="0"
    final += string
    file.write(final)


with open(path, 'w') as f:
    f.flush
    w = im.width
    h = im.height

    writeNum(w,f)
    writeNum(h,f)


    for j in range (h):
        for i in range (w):
            im = im.convert('RGB')
            r,g,b = im.getpixel((i,j))    
            n = 0
            n = b | g << 8 | r << 16;
            writeNum(n,f)
    f.write("z")
    
