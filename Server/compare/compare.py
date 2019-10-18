#count amount of lines in file
count = len(open("walmart.txt").readlines( ))
#file open 
file = open("walmart.txt" , "r")
#array to hold names of items
name = []
name2 = []

#for loop to populate word array
for line in file:
    fields = line.split(",")
    name.append(fields[0])

#close file
file.close()

count2 = len(open("run1.txt").readlines( ))
file = open("run1.txt" , "r")
for line in file:
    fields = line.split(",")
    name2.append(fields[0])
file.close()

#function to compare words
def compareWords(a,b):
    print("------------------------------------")
    l1=len(a)
    l2=len(b)
    half = float((l1+l2)/2)
    #converts the strings to lower case
    c = a.lower()
    d = b.lower()
    count = 0.0
    #for loop that checks each word in c against each word in b
    for word in c.split():
        if word in d.split():
            count += 1.0
    
    print(a)
    print(b)
    result = float(count/half)

    print(result)
    print("------------------------------------")

#iterate through the words to compare
for a in range(0,count):
    for c in range(0,count2):
        compareWords(name[a],name2[c])
       

