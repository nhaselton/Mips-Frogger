# Mips-Frogger

i saw MIPS had a bitmap and decided making a frogger "clone" would be a fun way to learn the language

How to run:

Must use Mars IDE, Make sure assemble all files in directory is true

Use the bitmap and keyboard MMIO tools

For bitmap 

 Pixel Size 8x8 
 
 Bitmap Size 512x512
 
 Base Address: 0x10000000 global data
 
 Also uses keyboard and display MMIO simulator
 
MMIO can be used as normal

Notes:
holding down a key will crash the IDE and you will have to use task manager to fix it, i'm not sure if its my fault or if its the programs fault

To edit a sprite, edit the .png file and drag it over convert.py to convert it to the proper sprite type

Sprites are made up of all 3 color values as binary and read in that way, its not even close to the most efficent way to do things but for the sake of simplicity it works

I have a notes text file with some findings, and things i'd do differently if i made another project




![alt text](https://github.com/nhaselton/Mips-Frogger/blob/9a8bdf41eab94c0a16d48ed7f1dfb9cafec04fe7/Sprites/Screenshot.png)
