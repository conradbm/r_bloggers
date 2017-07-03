###
### WRITTEN BY: BLAKE CONRAD
###

### LIBRARIES
import numpy as np # linear algebra
import pandas as pd # data processing, CSV file I/O (e.g. pd.read_csv)
from subprocess import check_output

### OPEN FILE & STORE
fileName = check_output(["ls", "../input"]).decode("utf8").rstrip()
print(fileName)
results=[]
with open("../input/colbert.csv", 'r') as f_in:
    results = list(map(lambda x:x.rstrip(), f_in.readlines()))

### CREATE DATAFRAME-READY LIST (i.e,.. create a list of rows)
container=[]
atom1=[]
atom2=[]
atom3=[]
for thing in results:
    row=[]
    ls1 = thing.split(",")
    row.append(ls1[0])
    row.append(ls1[1])
    row.append(''.join([s for s in ls1[2:]]))
    container.append(row)
df = pd.DataFrame(container[1:], columns=container[0])
#df.head() # CHECKPOINT_1

# DATA CLEANING & FEATURE ENGINEERING 1
df["caption_length"] = df["captions"].apply(lambda x:len(x))
df["captions"] = df["captions"].apply(lambda x:x.strip("\""))
df.head() # CHECKPOINT_2
