import os
import time
import numpy as np
import scipy.io as scio
from mainCL import cl

filePath = input("请输入文件路径：") # For example:  "/FCAG/FCA_G/dg2/cec20XX/"
adjMatPath = os.path.join(filePath, "adjacency")
sadjTxtPath = os.path.join(filePath,"sadjtxt")
sadjacencyPath = os.path.join(filePath,"sadjacency")

if not os.path.exists(sadjTxtPath):
    os.mkdir(sadjTxtPath)

if not os.path.exists(sadjacencyPath):
    os.mkdir(sadjacencyPath)

problem = 20 if "2010" in filePath else 15

for func in range(1,problem+1):
    print("func = %d" % func)
    adjTxtFileName = os.path.join(adjMatPath, "f%02d.mat" % func)
    outputFileName = os.path.join(sadjTxtPath,"sf%02d.txt" % func)
    startTime = time.time()
    cl(adjTxtFileName,outputFileName)
    filename = os.path.join(sadjTxtPath, "sf%02d.txt" % func)  # 待读取的文件的名称
    equiconcept = []
    with open(filename, "r") as f:
        for line in f:
            str = line.split("#")
            str[1] = str[1][:-1]  # 去除回车
            if str[0] == str[1]:
                equLine = str[0].split(" ")
                equiconcept.append([int(x) for x in equLine])
    # 求出列表的最大的长度
    maxLen = 0
    for eq in equiconcept:
        le = len(eq)
        if le > maxLen:
            maxLen = le
    res = np.zeros((len(equiconcept), maxLen), dtype=int)
    row = 0
    for eq in equiconcept:
        col = 0
        for e in eq:
            res[row, col] = e
            col += 1
        row += 1
    endTime = time.time()
    data = {"Adj": res, "sftime": np.array([endTime - startTime])}
    scio.savemat(os.path.join(sadjacencyPath, "sf%02d.mat" % func), data)
