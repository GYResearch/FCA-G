import lattice.mainCL as CL
import util.vo as vo
import util.basic as bs
import numpy as np

def InMainCL():

    filename = input("请输入文件名：")

    # 读入形式背景
    # filename = '/Users/yxyang/Desktop/test/test2.txt'

    with open(filename, "r") as f:
        numObj = int(f.readline())  # 获取对象数量
        numAttr = int(f.readline())  # 获取属性数量
        adjMat = np.zeros(shape=(numObj, numAttr), dtype=int)  # 存储形式背景矩阵
        obj = []
        attr = []

        # 将形式背景存储到矩阵内
        for i in range(numObj):
            obj.append(i + 1)
            for j in range(numAttr):
                adjMat[i][j] = int(f.read(1))
            f.read(1)

        for i in range(numAttr):
            attr.append(i + 1)


    # 计算原形式背景和补形式背景下的概念格cl,clC
    #cl = CL.cl(adjMat, obj, attr)
    cl = CL.cl()


    fileName = input("请输入增加的形式背景：")
    # fileName = '/Users/yxyang/Desktop/t6.txt'


    with open(fileName, "r") as f:
        numObj2 = int(f.readline())#获取对象数量
        numAttr2 = int(f.readline())#获取属性数量
        adjMat2 = np.zeros(shape=(len(obj)+numObj2, len(attr)+numAttr2), dtype=int)#存储完整的形式背景矩阵
        obj2= []
        attr2 = []

        #将节点增加后，由原形式背景更新为的新完整形式背景存储到矩阵内
        for i in range(len(obj)+numObj2):
            for j in range(len(attr)+numAttr2):
                t = int(f.read(1))
                adjMat2[i][j] = t
            f.read(1)

        for i in range(numAttr2):
            # attr2.append(len(attr) + i + 1)
            attr2.append(i+1)
        for i in range(numObj2):
            obj2.append(i+1)


    #将len(obj)*numAttr2的矩阵（即在原来的对象数量上只增加属性的矩阵）切割出来
    adjMatOfA = adjMat2[:len(obj), len(attr):len(attr)+numAttr2]


    cl2 = CL.cl(adjMatOfA, obj, attr2)#新加的形式背景概念格

    #获取各概念格中的外延集合
    objRes = cl.__getitem__(0)
    objRes2 = cl2.__getitem__(0)

    #属性增加后，更新属性集
    for i, index in enumerate(attr2):
        attr2[index-1] += len(attr)

    updateObjRes = set()#存储两个形式背景外延集合中元素的两两交运算的结果，即新外延集
    for i in objRes:
        for j in objRes2:
            updateObjRes.add(tuple(set(i).intersection(set(j))))


    # 这里删掉外延集合中空集和全集，是为了求内涵集合时不会有0元素而报错，后面再手动添加回来
    updateObjRes.remove(tuple(obj))
    updateObjRes.remove(tuple())


    # adjMat = np.concatenate([adjMat, adjMat2],axis=1)#将形式背景更新为属性增加后的新形式背景
    # adjMatC = np.concatenate([adjMatC, adjMat2C], axis=1)#更新补形式背景

    attrTotal = attr.copy()
    attrTotal.extend(attr2)


    #根据新的外延集合求内涵，得到概念格
    bpcObj = bs.BasicCL().getBPCliqueObj(adjMat2, obj, attrTotal, len(obj), len(attrTotal))
    bpcAttr = bs.BasicCL().getBPCliqueAttr(adjMat2, obj, attrTotal, len(obj), len(attrTotal))
    bp1, attrRes = bs.BasicCL().finalBpcAll(updateObjRes, bpcObj, bpcAttr)

    #添加特殊概念
    spcC1 = vo.Pair(tuple(obj), ())
    spcC2 = vo.Pair((), tuple(attrTotal))
    bp1.append(spcC1)
    bp1.append(spcC2)


    #--------------------
    #将增加的对象补齐，该矩阵大小为numObj2*len(attrTotal)
    adjMatOfO = adjMat2[len(obj):len(obj)+numObj2, :len(attrTotal)]



    cl3 = CL.cl(adjMatOfO, obj2, attrTotal)  # 新加的形式背景概念格

    # 获取各概念格中的外延集合
    attrRes.add(tuple())
    attrRes.add(tuple(attrTotal))
    attrRes3 = cl3.__getitem__(1)

    # 对象增加后，更新对象集
    for i, index in enumerate(obj2):
        obj2[index - 1] += len(obj)

    objTotal = obj.copy()
    objTotal.extend(obj2)

    updateAttrRes = set()  # 存储两个形式背景内涵集合中元素的两两交运算的结果，即新内涵集
    for i in attrRes:
        for j in attrRes3:
            updateAttrRes.add(tuple(set(i).intersection(set(j))))


    # 这里删掉外延集合中空集和全集，是为了求内涵集合时不会有0元素而报错，后面再手动添加回来
    updateAttrRes.remove(tuple(attrTotal))
    updateAttrRes.remove(tuple())


    # 根据新的外延集合求内涵，得到概念格
    bpcObj2 = bs.BasicCL().getBPCliqueObj(adjMat2, objTotal, attrTotal, len(objTotal), len(attrTotal))
    bpcAttr2 = bs.BasicCL().getBPCliqueAttr(adjMat2, objTotal, attrTotal, len(objTotal), len(attrTotal))
    # bp3, upObj = bs.BasicCL().finalBpcAllforExtent(updateAttrRes, bpcObj2, bpcAttr2)
    bp3 = bs.BasicCL().finalBpcAllforExtent(updateAttrRes, bpcObj2, bpcAttr2).__getitem__(0)


    # 添加特殊概念
    spcC1 = vo.Pair(tuple(objTotal), ())
    spcC2 = vo.Pair((), tuple(attrTotal))
    bp3.append(spcC1)
    bp3.append(spcC2)




    outFile = input("请输入写出结果的文件路径：")
    # outFile = '/Users/yxyang/Desktop/rs.txt'
    with open(outFile, 'w') as fi:

        fi.write("概念为:\n")
        for i in bp3:
            # print(i.getL(), i.getR())
            fi.write(str(i.getL())+"#"+str(i.getR())+"\n")




InMainCL()



