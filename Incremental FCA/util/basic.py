#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# @Author  : yixuan yang
# @File    : basic.py
import util.vo as vo


class BasicCL:

    dictAll = {}
    objResult = set()
    attrResult = set()
    bpcAllCL = set()


    #以对象为key,该对象对应的属性集为value的全对象字典，注：也可以考虑用dict存储
    def getBPCliqueObj(self, adjMat, obj, attr, numObj, numAttr):

        tmpBpc = []

        for i in range(numObj):
            tmpList = []
            tmpObj = obj.__getitem__(i)

            for j in range(numAttr):
                if(adjMat[i][j] == 1):
                    tmpList.append(attr.__getitem__(j))

            tmpPair = vo.Pair(tmpObj, tmpList)
            # print(tmpPair.getR())
            tmpBpc.append(tmpPair)

        return tmpBpc


    #以属性为key，该属性对应对象集为value的全属性字典
    def getBPCliqueAttr(self, adjMat, obj, attr, numObj, numAttr):
        tmpBpc = []

        for i in range(numAttr):
            tmpList = []
            tmpAttr = attr.__getitem__(i)

            for j in range(numObj):
                if(adjMat[j][i] == 1):
                    tmpList.append(obj.__getitem__(j))

            tmpPair = vo.Pair(tmpAttr, tmpList)
            # print(tmpPair.getR())
            tmpBpc.append(tmpPair)
        return tmpBpc


    #求概念格的外延集
    def objRes(self,obj,attr,bpcObj,bpcAttr):


        #将特殊概念放入,不然后期两两做交运算会丢失外延
        spcObj = []
        objTest = []
        for i in range(len(obj)):
            spcObj.append(obj.__getitem__(i))
        objTest.append(tuple(spcObj))#这里list为什么要转换为元组呢？因为set是哈希的，不可变的
                                    #存放的也必须是不可变的，元组和常量才可以存放，list,set都不可以
                                    #所以先转换为元组，python特性，
                                    #java没问题，可以直接hashset<ArrayList<String>>
        self.objResult = set(tuple(objTest))

        for i in range(len(attr)):
            objTemp = self.objResult.copy()#将objResult中所有外延集合复制到objTemp
                                        #方便后续做交运素，必须copy(),=给的是地址，交运算后objResult也会改变
                                        #python中set做并交运算效率比list高
            oneObj = set(bpcAttr.__getitem__(i).getR())
            for j in objTemp:
                temp = set(j)#元组不可做交运算，所以要转换为set
                temp.intersection_update(oneObj)
                temp = sorted(temp)
                #print("temp:", temp)
                self.objResult.add(tuple(temp))

        nullContent = ()
        if nullContent in self.objResult:

            self.objResult.remove(nullContent)#做交运算时会有空集的情况，
                                            #也会添加入set，所以最后必须去空集处理
            self.objResult.remove(tuple(spcObj))

        return self.objResult


    #获取每条外延所对应的内涵，obt为一条外延
    def intersectForObject(self, obt, bpcObj):

        tupTem = ()#存储obj对应的属性列表
        tmpPair = vo.Pair(0,0)

        count = 0
        obt = tuple(obt)
        leng = len(obt)

        if leng == 1:
            num = obt.__getitem__(0) - 1
            tupTem = tuple(bpcObj.__getitem__(num).getR())
        else:

            for i in obt:
                count = count + 1
                if len(tupTem) == 0 and count != leng:
                    tupTem = tuple(bpcObj.__getitem__(i - 1).getR())
                    #print(tupTem)
                else:
                        set1 = set(tupTem)
                        set2 = set(bpcObj.__getitem__(i -  1).getR())
                        set1.intersection_update(set2)
                        set1 = sorted(set1)
                        tupTem = tuple(set1)

        if(tupTem):
            tmpPair.setLR(tuple(obt), tupTem)

        return tmpPair


        # 获取每条外延所对应的内涵，obt为一条外延

    def intersectForObj(self, obt, bpcObj):

        tupTem = ()  # 存储obj对应的属性列表
        tmpPair = vo.Pair(0, 0)


        if (len(tupTem) == 0):
            tupTem = tuple(bpcObj.__getitem__(obt - 1).getR())
            # print(tupTem)
        else:
            set1 = set(tupTem)
            set2 = set(bpcObj.__getitem__(obt - 1).getR())
            set1.intersection_update(set2)
            set1 = sorted(set1)
            tupTem = tuple(set1)


        return tupTem


    #将外延集中所有外延的内涵求出并返回
    def finalBpcAll(self,objResult, bpcObj, bpcAttr):
        bpCliques = []
        attrResult = set()
        for obt in objResult:
            pair = self.intersectForObject(obt, bpcObj)
            if pair.getR() != 0:
                pair = self.intersectForObject(pair.getR(), bpcAttr)
                pair = pair.reversal()
                bpCliques.append(pair)
                attrResult.add(pair.getR())
            else:
                pass

        return bpCliques, attrResult

    # 将内涵集中所有内涵的外延求出并返回概念格
    def finalBpcAllforExtent(self, attrResult, bpcObj, bpcAttr):
        bpCliques = []
        objResult = set()
        for att in attrResult:
            pair = self.intersectForObject(att, bpcAttr)
            pair = self.intersectForObject(pair.getR(), bpcObj)
            bpCliques.append(pair)
            objResult.add(pair.getL())

        return bpCliques, objResult



