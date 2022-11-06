import numpy as np
import util.basic as basic
import util.vo as vo
import scipy.io as scio


#if __name__ == "__main__":
def cl(filename,fname):

    # filename = input("请输入文件名：")

    #读入形式背景
    #filename = 'C:\Users\chang fengrong\Desktop\formcontext\f03.txt'

    # 改进的
    data = scio.loadmat(file_name=filename)
    adjMat = data.get("Adj")
    numObj, numAttr = adjMat.shape
    obj = [i+1 for i in range(numObj)]
    attr = [i+1 for i in range(numAttr)]

    bpcObj = basic.BasicCL().getBPCliqueObj(adjMat, obj, attr, numObj, numAttr)
    bpcAttr = basic.BasicCL().getBPCliqueAttr(adjMat, obj, attr, numObj, numAttr)

    objResult = basic.BasicCL().objRes(obj, attr, bpcObj, bpcAttr)

    bpCliques = basic.BasicCL().finalBpcAll(objResult, bpcObj, bpcAttr).__getitem__(0)

    unspcBpcliques = bpCliques.copy()

    spcObj = []
    for i in range(len(obj)):
        spcObj.append(obj.__getitem__(i))
    spcAttr = []
    for i in range(len(attr)):
        spcAttr.append(attr.__getitem__(i))
    spcObj = tuple(spcObj)
    spcAttr = tuple(spcAttr)

    spcC1 = vo.Pair(spcObj, ())
    spcC2 = vo.Pair((), spcAttr)
    bpCliques.append(spcC1)
    bpCliques.append(spcC2)

    with open(fname, 'w') as file:
        # iii = 1
        for temp in bpCliques:
            # print("iii = %d" % iii)
            # iii += 1
            str2 = ' '.join('%s' % id for id in temp.getL()) + '#' + ' '.join('%s' % id for id in temp.getR())
            file.write(str2)
            file.write('\n')

    # 原先的
    # with open(filename, "r") as f:
    #     numObj = int(f.readline())#获取对象数量
    #     numAttr = int(f.readline())#获取属性数量
    #     adjMat = np.zeros(shape=(numObj, numAttr), dtype=int)#存储形式背景矩阵
    #     obj = []
    #     attr = []
    #
    #     #将形式背景存储到矩阵内
    #     for i in range(numObj):
    #         obj.append(i+1)
    #         for j in range(numAttr):
    #             adjMat[i][j] = int(f.read(1))
    #         f.read(1)
    #
    #     for i in range(numAttr):
    #         attr.append(i+1)
    #
    #
    #
    #     bpcObj = basic.BasicCL().getBPCliqueObj(adjMat,obj,attr,numObj,numAttr)
    #     bpcAttr = basic.BasicCL().getBPCliqueAttr(adjMat,obj,attr,numObj,numAttr)
    #
    #     objResult = basic.BasicCL().objRes(obj,attr,bpcObj,bpcAttr)
    #
    #     bpCliques = basic.BasicCL().finalBpcAll(objResult,bpcObj, bpcAttr).__getitem__(0)
    #
    #     unspcBpcliques = bpCliques.copy()
    #
    #     spcObj = []
    #     for i in range(len(obj)):
    #         spcObj.append(obj.__getitem__(i))
    #     spcAttr = []
    #     for i in range(len(attr)):
    #         spcAttr.append(attr.__getitem__(i))
    #     spcObj = tuple(spcObj)
    #     spcAttr = tuple(spcAttr)
    #
    #     spcC1 = vo.Pair(spcObj,())
    #     spcC2 = vo.Pair((),spcAttr)
    #     bpCliques.append(spcC1)
    #     bpCliques.append(spcC2)
    #
    #     #for temp in bpCliques:
    #         #print(temp.getL(),"#",temp.getR())
    #
    #     # fname = input("请输入写出概念的文件名：")
    #     with open(fname,'w') as file:
    #         for temp in bpCliques:
    #             str2 = ' '.join('%s' %id for id in temp.getL()) + '#' + ' '.join('%s' %id for id in temp.getR())
    #             file.write(str2)
    #             file.write('\n')


        #print(objResult)
    return objResult, bpCliques, adjMat, obj, attr, bpcObj,bpcAttr,numObj,numAttr, unspcBpcliques


if __name__ == '__main__':
    # for i in [13,18,20]:
    #     cl(r"D:\personalfiles\研究生\作业\NCAA\实验结果\FCAG\FCA_G\Thetas\2010\f%02d.mat" % i,
    #        r"D:\personalfiles\研究生\作业\NCAA\实验结果\FCAG\FCA_G\sadjs\2010\sf%02d.txt" % i)
    #
    # for i in [12]:
    #     cl(r"D:\personalfiles\研究生\作业\NCAA\实验结果\FCAG\FCA_G\Thetas\2013\f%02d.mat" % i,
    #        r"D:\personalfiles\研究生\作业\NCAA\实验结果\FCAG\FCA_G\sadjs\2013\sf%02d.txt" % i)
    for i in [13,18,20]:
        filename = r"D:\personalfiles\研究生\作业\NCAA\实验结果\FCAG\FCA_G\sadjs\2010\sf%02d.txt" % i
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

        data = {"Adj": res}
        scio.savemat(r"D:\personalfiles\研究生\作业\NCAA\实验结果\FCAG\FCA_G\sadjs\2010\sf%02d.mat" % i, data)

