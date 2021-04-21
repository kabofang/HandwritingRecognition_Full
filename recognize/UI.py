import numpy as np
import matlab.engine
eng=matlab.engine.start_matlab()
with open('..\\IO\\ret','r') as sourcefile:
    sourcestr=sourcefile.readlines()
lst=[[0 for i in range(28)] for i in range(28)]
for i in range(28*28):
    lst[i//28][i%28]=int(sourcestr[0][i])
lst=matlab.int8(lst)
ret=eng.recognize(lst)
print('result is '+str(ret))