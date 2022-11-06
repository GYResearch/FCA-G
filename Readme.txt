The optimal results found by FCA-G are saved in the File:  "./FCAG/optimizationResults/cec20XX/fXX.mat"

The following is the detailed procedures to run FCA-G:
1.  Use "Incremental FCA" to get the grouping results:   Run "test.py" and enter the directory above the folder where form context is located, like "./FCAG/FCA_G/dg2/cec20XX/adjacency/". And the grouping results will be stored in the same directory as form context, such as "./FCAG/FCA_G/dg2/cec2010/sadjacency".
2.  Run "./FCAG/FCA_G/saveGroupResult2010.m"  or "./FCAG/FCA_G/saveGroupResult2013.m" to keep the grouping results to "./FCAG/FCA_G/groupResult/cecXXXX/FXX.mat"
3.  Run the "run2010.m" or  "run2013.m" to get the optima of test problems of CEC2010 and CEC2013 found by FCA-G. And save the optimization results to "./FCAG/optimizationResults/cecXXXX/fXX.mat".

