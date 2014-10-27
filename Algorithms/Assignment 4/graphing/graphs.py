import matplotlib.pyplot as plt
import os

theDir = "Algorithms"
outDir = theDir + os.sep + "Graphs"
print outDir
files = ["Insertion.txt", "Selection.txt", "Quick.txt", "Merge.txt", "Heap.txt"]

data = {}
for file in files:
	data[file] = []
	data[file] = [(line.split(',')[0], line.split(',')[1]) for line in open(theDir + os.sep + file, "rb").read().splitlines()]
for i in range(len(files)):
	#plt.subplot(3, 2, i)
	#plt.subplot(1,1,1)
	plt.clf()
	fileData = data[files[i]]
	plt.scatter([f[0] for f in fileData], [f[1] for f in fileData])
	plt.title(files[i])
	plt.xlabel("Array Size")
	plt.ylabel("Comparisons")
	plt.savefig(outDir + os.sep + files[i] + ".png")

#plt.show()
print "Done"