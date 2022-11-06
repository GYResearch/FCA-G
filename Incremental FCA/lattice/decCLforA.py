import lattice.mainCL as cl
import numpy as np
import util.basic as basic
import util.vo as vo

if __name__=="__main__":
    cl1 = cl.cl()
    objRs = cl1.__getitem__(0)
    bpCliques = cl1.__getitem__(1)
    adjMat = cl1.__getitem__(2)
    newAdjMat = np.copy(adjMat)
    newAdjMat1 = np.array(newAdjMat)
    obj = cl1.__getitem__(3)
    attr = cl1.__getitem__(4)
    numObj = cl1.__getitem__(7)
    numAttr = cl1.__getitem__(8)
    a = len(obj)

    for bp in bpCliques:
        print(bp.getL(),"#",bp.getR())

    newBpCliques = []

    #将要删除的属性输入
    #请输入文件名：/Users/yxyang/Desktop/test/test1.txt
    filename = input("请输入要删除的属性编号的文件：")
    with open(filename, "r") as f:

        str = f.readline()
        strs = str.split(",")
        dAttr = list(map(int,strs))#获取要修改的属性


        for i in range(len(dAttr)):
            newAdjMat[:,dAttr[i]-1] = np.zeros(len(obj))#重置矩阵，将要删掉的属性与对象的关系置为0

        dAttrSet = set(dAttr)

        #print(newAdjMat)

        bpcObj = basic.BasicCL().getBPCliqueObj(newAdjMat, obj, attr, numObj, numAttr)
        bpcAttr = basic.BasicCL().getBPCliqueAttr(newAdjMat, obj, attr, numObj, numAttr)


        #过滤已有概念，内涵中含有要删除属性的概念拿出来重新计算
        for temp in bpCliques:
            #setR = set(temp.getR())
            #if len(setR & dAttrSet) == 0:#判断每一个概念的内涵是否存在要删除的属性，若不存在，该概念将不变，存在就用更新的字典重新计算
                #newBpCliques.append(temp)
            #else:
                #tmPair = basic.BasicCL().intersectForObject(temp.getL(),bpcObj)#用更新后的字典重新计算内涵改变的概念
                #newBpCliques.append(tmPair)

            setR = set(temp.getR())
            if len(setR & dAttrSet) == 0:  # 判断每一个概念的内涵是否存在要删除的对象，若不存在，该概念将不变，存在就用更新的字典重新计算
                newBpCliques.append(temp)
            else:
                tmPair = basic.BasicCL().intersectForObject(temp.getL(), bpcObj)  # 用更新后的字典重新计算内涵改变的概念
                if type(tmPair.getL()) is int:
                    pass
                else:
                    tmPair = basic.BasicCL().intersectForObject(tmPair.getR(), bpcAttr)
                    tmPair = tmPair.reversal()
                    # tmsPair = vo.Pair(tmPair.getR(),tmPair.getL())
                    # newBpCliques.append(tmsPair)
                    newBpCliques.append(tmPair)

        newSet = set(newBpCliques)

        #newBpCliques.remove(vo.Pair(0,0))#随着一些属性减少，有一些概念将消失，在else的intersectForObject
                                            # 运算后就会获得（0，0），从Set中删掉

        for t in newSet:
            print(t.getL(),"#",t.getR())






