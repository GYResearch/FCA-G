import numpy as np
if __name__ == "__main__":


    filename = input("输入文件名：")#/Users/yxyang/Desktop/result/sns.txt
    #finame = '/Users/yxyang/Desktop/result/karate/karate3.txt'
    #fina = open(finame,'w')

    with open(filename, "r") as f:
        numObj = int(f.readline())  # 获取对象数量
        numAttr = int(f.readline())  # 获取属性数量
        adjMat = np.zeros(shape=(numObj, numAttr), dtype=int)  # 存储形式背景矩阵

        for i in range(numObj):
            for j in range(numAttr):
                adjMat[i][j] = int(f.read(1))
                #fina.write(str(adjMat[i][j]))
            f.read(1)
            #fina.write('\n')


        subNum = input("输入切割矩阵的对象数1：")
        subNum3 = input("输入切割矩阵的对象数2：")
        subNum2 = input("输入切割矩阵的属性数1：")
        subNum4 = input("输入切割矩阵的属性数2：")
        a = int(subNum)
        a1 = int(subNum3)
        c = int(subNum2)
        c2 = int(subNum4)
        # b = numObj - a



        fname1 = input("请输入写出的第一个文件名：")
        #fname2 = input("请输入写出的第二个文件名：")
        f1 = open(fname1, 'w')
        #f2 = open(fname2, 'w')

        adjMat1 = np.zeros(shape=(a1 - a +1, c2 - c+1), dtype=int)
        an = str(a1 - a+1)
        f1.write(an)
        f1.write('\n')
        f1.write(str(c2 - c+1))
        f1.write('\n')
        for i in range(a1-a+1):
            for j in range(c2-c+1):
                adjMat1[i][j] = adjMat[a-1+i][c-1+j]
                f1.write(str(adjMat1[i][j]))
            f1.write('\n')

        '''
        adjMat2 = np.zeros(shape=(b, b), dtype=int)
        bn = str(b)
        f2.write(bn)
        f2.write('\n')
        f2.write(bn)
        f2.write('\n')
        for i in range(b):
            for j in range(b):
                adjMat2[i][j] = adjMat[a+i][a+j]
                f2.write(str(adjMat[a+i][a+j]))
            f2.write('\n')
        '''

