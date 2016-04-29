#!/usr/bin/env python
# -*- coding: utf-8 -*-
# Dylan @ 2016-04-29 10:38:40
import os
import numpy as np
import re

def GetFileFromRootDir(dir, ext=None):
    allfiles = []
    needExtFilter = (ext !=None)
    for root, dirs, files in os.walk(dir):
        for filespath in sorted(files):
            filepath=os.path.join(root,filespath)
            extension=os.path.splitext(filepath)[1][1:]
            if needExtFilter and extension in ext:
                allfiles.append(filepath)
            elif not needExtFilter:
                allfiles.append(filepath)
    return allfiles

def getArrayFromPattern(pattern):
    array=[]
    pattern=re.sub(r"\/[A-Z]:",",",pattern)
    array=re.split(r"[^a-z0-9A-Z]",pattern)
    i=0
    while i< len(array):#some feature values may be negative -5
        if array[i]=="":
            array.pop(i)
            array[i]="-"+array[i]
        i+=1
    return array


"""
featnamearray is a input array contains featurename
feattypedict is featuretype diction
featdict is feature value mapping dictionary
"""
def number2vector(featnamearray, feattypedict, featdict, dataarrays):
    featurearrays=[]
    for dataarray in dataarrays:
        featurearray=[]
        for x in xrange(len(dataarray)):
            if feattypedict[featnamearray[x]]==1:
                vector=[0 for y in featdict[featnamearray[x]].values()]
                vector[featdict[featnamearray[x]][dataarray[x]]]=1
                featurearray=featurearray+vector
            else :
                pass
        featurearrays.append(featurearray)
    return np.array(featurearrays,dtype=np.float32)


