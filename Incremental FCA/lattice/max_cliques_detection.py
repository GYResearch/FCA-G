
import os
import numpy as np
import scipy.io as scio

filePath = input("请输入文件路径：")
sAdjTxtPath = os.path.join(filePath,"sadjtxt")
outputPath = os.path.join(filePath,"sadjacency")

if not os.path.exists(outputPath):
    os.mkdir(outputPath)

problem = 20 if "2010" in filePath else 15

for func in range(1,problem+1):
    filename = os.path.join(sAdjTxtPath,"sf%02d.txt" % func) # 待读取的文件的名称
    equiconcept = []
    with open(filename, "r") as f:
        for line in f:
            str = line.split("#")
            str[1] = str[1][:-1] # 去除回车
            if str[0] == str[1]:
                equLine = str[0].split(" ")
                equiconcept.append([int(x) for x in equLine])
    # 求出列表的最大的长度
    maxLen = 0
    for eq in equiconcept:
        le = len(eq)
        if le > maxLen:
            maxLen = le
    res = np.zeros((len(equiconcept),maxLen),dtype=int)
    row = 0
    for eq in equiconcept:
        col = 0
        for e in eq:
            res[row,col] = e
            col += 1
        row += 1
    data = {"Adj":res}
    scio.savemat(os.path.join(outputPath,"sf%02d.mat" % func),data)


    # for eq in equiconcept:
    #     line = eq.split(" ")
    # data = {"Adj":equiconcept}
    # scio.savemat(,data)


# if __name__ == '__main__':
#
#     equiconcept = []
#
#     filename = input("输入第一个文件名：")
#     #/Users/yxyang/Desktop/result/karate/karate2.txt
#
#     with open(filename, "r") as f:
#         for line in f:
#             str = line.split("#")
#             str[1] = str[1][:-1]
#             if str[0] == str[1]:
#                 equiconcept.append(str[0])
#
#
#
#     for t in equiconcept:
#         #print(t,'#',t)
#         print(t)
#
#     #filename2 = input("输入第二个文件名：")
#
#     #equiconcept2 = []
#     #with open(filename2, "r") as f:
#         #for line in f:
#             #str = line.split("#")
#             #str[1] = str[1][:-1]
#             #if str[0] == str[1]:
#                 #equiconcept2.append(str[0])
#
#     #for t in equiconcept2:
#         #print(t, '#', t)
#     #print('第一次有', len(equiconcept),'个等式概念', '第二次有', len(equiconcept2),'个等式概念')
#     print('第一次有', len(equiconcept), '个等式概念')
#     #same = [x for x in equiconcept if x in equiconcept2]
#     #different = [y for y in (list1 + list2) if y not in c]
#     #add = [y for y in equiconcept2 if y not in same]
#
#     #different = [y for y in equiconcept if y not in equiconcept2]
#     #different2 = [y for y in equiconcept2 if y not in equiconcept]
#
#
#
#
#     #print('相同的等式概念有：', len(same), '个')
#     #print('相同的等式概念有：')
#     #'''
#     #for t in same:
#     #    print(t, '#', t)
#     #'''
#
#
#     #print('改变了的等式概念有：', len(add), '个')
#     #print('改变了的等式概念有：')
#     #for t in add:
#         #print(t, '#', t)
#
#     #print('--------------------------------')
#
#     #print('diff1:', len(different), 'diff2:', len(different2)-len(different))
#
#     #for t in different:
#         #print(t, '#', t)
#
#
#
#
#
