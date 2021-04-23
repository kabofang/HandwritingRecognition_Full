import scipy.io as sio
import tkinter
from PIL import Image,ImageTk

white = (255, 255, 255)
black = (0, 0, 0)
orgwidth = 28
orgheight = 28
countcol=12

t=tkinter.Tk();
t.title('Feature Show')
t.geometry('1020x640')

Featuresmat=sio.loadmat('.\\IO\\Feature_6.mat')
Origin=Featuresmat['Origin']
Features1=Featuresmat['ConV1_feature']
Features2=Featuresmat['ConV2_feature']

ShowFrame=tkinter.Frame(t,bd =0,relief = "groove")
image = Image.new('RGB', (orgwidth, orgheight), 'white')
One = Origin.T
for k in range(orgheight):
    for j in range(orgwidth):
        if (One[k][j] > 0):
            image.putpixel((k, j), white)
        else:
            image.putpixel((k, j), black)
Im_exp = image.resize((256, 256), Image.ANTIALIAS)
m = ImageTk.PhotoImage(Im_exp)
biglab=tkinter.Label(ShowFrame, image=m)
biglab.pack()

ShowFrame.grid()

divideFrame1=tkinter.Frame(t,bd =0,relief = "groove")
dividelab=tkinter.Label(divideFrame1,height=2,text='First Convolution',font=('Lucida Calligraphy',12)).grid(row=1,column=0)
divideFrame1.grid()

Features1Frame=tkinter.Frame(t,bd =0,relief = "groove")

Lab=list(range(len(Features1[0,0,:])))
Im_Photo=list(range(len(Features1[0,0,:])))
for i in range(len(Features1[0,0,:])):
    One=Features1[:,:,i].T
    image = Image.new('RGB', (24, 24), 'white')
    for k in range(24):
        for j in range(24):
            image.putpixel((k, j), (int(One[k,j]),int(One[k,j]),int(One[k,j])))
    Im_exp = image.resize((81, 81), Image.ANTIALIAS)
    Im_Photo[i] = ImageTk.PhotoImage(Im_exp)
    Lab[i] = tkinter.Label(Features1Frame,image=Im_Photo[i])
    Lab[i].grid(row=2 * (i // countcol)+1, column=i % countcol)

Features1Frame.grid()

divideFrame2=tkinter.Frame(t,bd =0,relief = "groove")
dividelab=tkinter.Label(divideFrame2,height=2,text='Second Convolution',font=('Lucida Calligraphy',12)).grid(row=0,column=0)
divideFrame2.grid()

Features2Frame=tkinter.Frame(t,bd =0,relief = "groove")

Lab2=list(range(len(Features2[0,0,:])))
Im_Photo2=list(range(len(Features2[0,0,:])))
for i in range(len(Features2[0,0,:])):
    One=Features2[:,:,i].T
    image = Image.new('RGB', (10, 10), 'white')
    for k in range(10):
        for j in range(10):
            image.putpixel((k, j), (int(One[k,j]),int(One[k,j]),int(One[k,j])))
    Im_exp = image.resize((81, 81), Image.ANTIALIAS)
    Im_Photo2[i] = ImageTk.PhotoImage(Im_exp)
    Lab2[i] = tkinter.Label(Features2Frame,image=Im_Photo2[i])
    Lab2[i].grid(row=2 * (i // countcol)+1, column=i % countcol)

Features2Frame.grid()

t.mainloop()