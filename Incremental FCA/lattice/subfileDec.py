import numpy as np
if __name__ == "__main__":


    filename = input("输入文件名：")#/Users/yxyang/Desktop/result/sns.txt

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


        fl = input("输入要删除掉的节点：")
        with open(fl, "r") as f:

            strt = f.readline()
            strs = strt.split(",")
            dObj = list(map(int, strs))  # 获取要修改的对象，文件内格式为：1，3，4（以逗号隔开）
            dAttr = dObj

            for i in range(len(dObj)):
                adjMat[dObj[i] - 1, :] = np.zeros(numAttr)
                adjMat[:, dAttr[i] - 1] = np.zeros(numObj)



        fname1 = input("请输入写出的文件名：")
        #fname2 = input("请输入写出的第二个文件名：")
        f1 = open(fname1, 'w')
        #f2 = open(fname2, 'w')

        num = str(numObj)

        f1.write(num)
        f1.write('\n')
        f1.write(num)
        f1.write('\n')
        for i in range(numObj):
            for j in range(numAttr):
                f1.write(str(adjMat[i][j]))
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

