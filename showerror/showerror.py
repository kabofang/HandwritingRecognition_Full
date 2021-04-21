import scipy.io as sio
import tkinter
from PIL import Image,ImageTk

global biglab
global bigtextlab
global ShowFrame

white = (255, 255, 255)
black = (0, 0, 0)
orgwidth = 28
orgheight = 28
countcol=23

t=tkinter.Tk();
t.title('Error Show')
t.geometry('1020x720')

Error=sio.loadmat('..\\IO\\Error.mat')
ErrorIndex=Error['Error']
TestData=sio.loadmat('..\\IO\\MNISTData.mat')
Datamat=TestData['Data_test_in']
Outmat=TestData['Data_test_out']

def DCProc(event):
    global biglab
    global bigtextlab
    orgstr=str(event.widget)
    lst=orgstr.split('l')
    num=int(lst[len(lst)-1])
    i=num//2
    image = Image.new('RGB', (orgwidth, orgheight), 'white')
    One = Datamat[:, :, ErrorIndex[0][i] - 1].T
    for k in range(orgheight):
        for j in range(orgwidth):
            if (One[k][j] > 0):
                image.putpixel((k, j), white)
            else:
                image.putpixel((k, j), black)
    Im_exp = image.resize((150, 150), Image.ANTIALIAS)
    m = ImageTk.PhotoImage(Im_exp)
    for j in range(10):
        if (Outmat[j, ErrorIndex[0][i] - 1] != 0):
            num = (j + 1) % 10
    biglab.config(image=m)
    biglab.image=m
    bigtextlab.config(text='Realvalue is {}\nrecognition is {}'.format(num, ErrorIndex[1][i] % 10))
    bigtextlab.text='Realvalue is {}\nrecognition is {}'.format(num, ErrorIndex[1][i] % 10)
    ShowFrame.grid()


ShowFrame=tkinter.Frame(t,bd =0,relief = "groove")
image = Image.new('RGB', (orgwidth, orgheight), 'white')
One = Datamat[:, :, ErrorIndex[0][0]-1].T
for k in range(orgheight):
    for j in range(orgwidth):
        if (One[k][j] > 0):
            image.putpixel((k, j), white)
        else:
            image.putpixel((k, j), black)
Im_exp = image.resize((150, 150), Image.ANTIALIAS)
m = ImageTk.PhotoImage(Im_exp)
biglab=tkinter.Label(ShowFrame, image=m)
biglab.grid(row=0, column=0)
for j in range(10):
    if (Outmat[j, ErrorIndex[0][0]-1] != 0):
        num = (j + 1) % 10
bigtextlab=tkinter.Label(ShowFrame,text='Realvalue is {}\nrecognition is {}'.\
              format(num,ErrorIndex[1][0]%10),font=('微软雅黑',10))
bigtextlab.grid(row=1, column=0)
ShowFrame.grid()


Lab=list(range(len(ErrorIndex[0])))
ErrorFrame=tkinter.Frame(t,bd =0,relief = "groove")
Im_Photo=list(range(len(ErrorIndex[0])))
for i in range(len(ErrorIndex[0])):
    One=Datamat[:,:,ErrorIndex[0][i]-1].T
    image = Image.new('RGB', (orgwidth, orgheight), 'white')
    for k in range(orgheight):
        for j in range(orgwidth):
            if (One[k][j] > 0):
                image.putpixel((k, j), white)
            else:
                image.putpixel((k, j), black)
    Im_exp = image.resize((40, 40), Image.ANTIALIAS)
    Im_Photo[i] = ImageTk.PhotoImage(Im_exp)
    Lab[i] = tkinter.Label(ErrorFrame,width=0,height=0,pady=0,image=Im_Photo[i])
    Lab[i].grid(row=2 * (i // countcol), column=i % countcol)
    for j in range(10):
        if(Outmat[j,ErrorIndex[0][i]-1]!=0):
            num=(j+1)%10
    tkinter.Label(ErrorFrame,text='{}    {}'.format(num,ErrorIndex[1][i]%10),\
                        width=5,height=0,pady=0,fg='red',bg='black').grid(row=2*(i//countcol)+1,column=i % countcol)
ErrorFrame.grid()


for lab in Lab:
    lab.bind('<Double-Button-1>',DCProc)


t.mainloop()

















