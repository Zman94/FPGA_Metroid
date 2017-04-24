from PIL import Image

ims = [Image.open("../sprites/NEW/block_blue.png"),
       Image.open("../sprites/NEW/block_gray.png"),
       Image.open("../sprites/NEW/block_green.png"),
       Image.open("../sprites/NEW/block_moss_blue.png"),
       Image.open("../sprites/NEW/blue_door_botmid.png"),
       Image.open("../sprites/NEW/blue_door_botright.png"),
       Image.open("../sprites/NEW/blue_door_bottop.png"),
       Image.open("../sprites/NEW/blue_door_left.png"),
       Image.open("../sprites/NEW/EN_indicate.png"),
       Image.open("../sprites/NEW/EN.png"),
       Image.open("../sprites/NEW/enemy1.png"),
       Image.open("../sprites/NEW/enemy2.png"),
       Image.open("../sprites/NEW/enemy3.png"),
       Image.open("../sprites/NEW/explosion1.png"),
       Image.open("../sprites/NEW/explosion2.png"),
       Image.open("../sprites/NEW/health.png"),
       Image.open("../sprites/NEW/Running_forward_3.png"),
       Image.open("../sprites/NEW/Samus_jumping_forward.png"),
       Image.open("../sprites/NEW/Samus_jumping_up.png"),
       Image.open("../sprites/NEW/Samus_running_forward_2.png"),
       Image.open("../sprites/NEW/Samus_running_forward1.png"),
       Image.open("../sprites/NEW/Samus_standing_up.png"),
       Image.open("../sprites/NEW/Standing_forward.png"),
       Image.open("../sprites/NEW/Game_Over.png"),
       Image.open("../sprites/NEW/end.png"),
       Image.open("../sprites/NEW/Kraid.png"),
       Image.open("../sprites/NEW/kraid_shoot.png"),
       Image.open("../sprites/NEW/Kraid-throw.png"),
       Image.open("../sprites/NEW/Kraid_g.png"),
       Image.open("../sprites/NEW/Kraid_r.png"),
       Image.open("../sprites/NEW/title.gif"),]

saveLocations = ["../sprites/MODIFIED/block_blue.png",
                 "../sprites/MODIFIED/block_gray.png",
                 "../sprites/MODIFIED/block_green.png",
                 "../sprites/MODIFIED/block_moss_blue.png",
                 "../sprites/MODIFIED/blue_door_botmid.png",
                 "../sprites/MODIFIED/blue_door_botright.png",
                 "../sprites/MODIFIED/blue_door_bottop.png",
                 "../sprites/MODIFIED/blue_door_left.png",
                 "../sprites/MODIFIED/EN_indicate.png",
                 "../sprites/MODIFIED/EN.png",
                 "../sprites/MODIFIED/enemy1.png",
                 "../sprites/MODIFIED/enemy2.png",
                 "../sprites/MODIFIED/enemy3.png",
                 "../sprites/MODIFIED/explosion1.png",
                 "../sprites/MODIFIED/explosion2.png",
                 "../sprites/MODIFIED/health.png",
                 "../sprites/MODIFIED/Running_forward_3.png",
                 "../sprites/MODIFIED/Samus_jumping_forward.png",
                 "../sprites/MODIFIED/Samus_jumping_up.png",
                 "../sprites/MODIFIED/Samus_running_forward_2.png",
                 "../sprites/MODIFIED/Samus_running_forward1.png",
                 "../sprites/MODIFIED/Samus_standing_up.png",
                 "../sprites/MODIFIED/Standing_forward.png",
                 "../sprites/MODIFIED/Game_Over.png",
                 "../sprites/MODIFIED/end.png",
                 "../sprites/MODIFIED/Kraid.png",
                 "../sprites/MODIFIED/kraid_shoot.png",
                 "../sprites/MODIFIED/Kraid_throw.png",
                 "../sprites/MODIFIED/Kraid_g.png",
                 "../sprites/MODIFIED/Kraid_r.png",
                 "../sprites/MODIFIED/title.png",]

saveLocations2 = ["../sprites/TEXT/block_blue.txt",
                  "../sprites/TEXT/block_gray.txt",
                  "../sprites/TEXT/block_green.txt",
                  "../sprites/TEXT/block_moss_blue.txt",
                  "../sprites/TEXT/blue_door_botmid.txt",
                  "../sprites/TEXT/blue_door_botright.txt",
                  "../sprites/TEXT/blue_door_bottop.txt",
                  "../sprites/TEXT/blue_door_left.txt",
                  "../sprites/TEXT/EN_indicate.txt",
                  "../sprites/TEXT/EN.txt",
                  "../sprites/TEXT/enemy1.txt",
                  "../sprites/TEXT/enemy2.txt",
                  "../sprites/TEXT/enemy3.txt",
                  "../sprites/TEXT/explosion1.txt",
                  "../sprites/TEXT/explosion2.txt",
                  "../sprites/TEXT/health.txt",
                  "../sprites/TEXT/Running_forward_3.txt",
                  "../sprites/TEXT/Samus_jumping_forward.txt",
                  "../sprites/TEXT/Samus_jumping_up.txt",
                  "../sprites/TEXT/Samus_running_forward_2.txt",
                  "../sprites/TEXT/Samus_running_forward1.txt",
                  "../sprites/TEXT/Samus_standing_up.txt",
                  "../sprites/TEXT/Standing_forward.txt",
                  "../sprites/TEXT/Game_Over.txt",
                  "../sprites/TEXT/end.txt",
                  "../sprites/TEXT/Kraid.txt",
                  "../sprites/TEXT/Kraid_throw.txt",
                  "../sprites/TEXT/kraid_shoot.txt",
                  "../sprites/TEXT/Kraid_r.txt",
                  "../sprites/TEXT/Kraid_g.txt",
                  "../sprites/TEXT/title.txt",]

pallette = [(255,111,207),
            (44,92,10),
            (248,146,56),
            (156,0,18),
            (0,255,128),
            (0,0,128),
            (0,128,255),
            (255,255,255),
            (0,0,0),
            (0,0,255),
            (102,102,102),
            (0,255,255),
            (0,255,0),
            (64,128,0),
            (255,0,0),
            (255,102,102),
            (128,0,0),
            (248,146,56),
            (232,146,41),
            (27,175,0),
            (19,137,13),
            (255,49,62),
            (234,228,94),
            (126,0,246),
            (47,151,209),
            (156,89,33),
            (82,105,250),
            (43,93,83),
            (13,65,63),
            (37,75,258),
            (148,148,118),
            (60,70,17),
            (63,71,73),
            (34,28,28),
            (4,35,248),
            (186,0,37),
            (126,0,246),
            (103,0,183)]
pix = list()
closestColorList = list()
background_ims = 0
minDistance = -1

for image in ims:
    pix.append(image.load())

for z in range(len(ims)):
    closestColorList.append(list())
    xsize = ims[z].size[0]
    ysize = ims[z].size[1]
    pngtext = [[0 for x in range(xsize)] for y in range(ysize)]

    if xsize == 30 and ysize == 30:
        background_ims+=1

    print(ims[z].size) #Get the width and hight of the image for iterating over

    for y in range(ysize):
        for x in range(xsize):
            for color in range(len(pallette)):
                distance = (pix[z][x,y][0]-pallette[color][0])**2+(pix[z][x,y][1]-pallette[color][1])**2+(pix[z][x,y][2]-pallette[color][2])**2
                if distance < minDistance or minDistance < 0:
                    minDistance = distance
                    # closestColor = pallette[color]
                    closestColor = color
            closestColorList[z].append(closestColor)
            pngtext[y][x]=closestColor
            minDistance = -1

    # for y in range(ysize):
    #     for x in range(xsize):
    #         # print(closestColorList[x+y*xsize],end="")
    #     print()

    imw = Image.new( 'RGB', (xsize,ysize), "black") # create a new black
    pixw = imw.load()
    for y in range(ysize):
        for x in range(xsize):
            pixw[x,y] = pallette[closestColorList[z][x+y*xsize]] # Set the RGBA Value of the image (tuple)
    imw.save(saveLocations[z])

    with open(saveLocations2[z], 'w') as f:
        f.write("\'{")
        lastLine = pngtext[-1]
        for y in range(len(pngtext)):
            f.write("\'{")
            for x in range(len(pngtext[y])):
                if x == len(pngtext[y])-1:
                    f.write(str(pngtext[y][x]))
                    continue
                f.write(str(pngtext[y][x]) + ",")
            if y == len(pngtext)-1:
                f.write("}")
                break
            f.write("},\n")
        f.write("};\n\n")
        f.write("x = "+str(xsize)+"\n")
        f.write("y = "+str(ysize)+"\n")

print(background_ims)
