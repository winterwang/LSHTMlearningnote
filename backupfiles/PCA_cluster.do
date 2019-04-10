cd   "/home/takeshi/ドキュメント/githubprojects/LSHTMlearningnote/backupfiles" //change the path accordingly
log using pca.log, append

*------------------------------------------------------------------------------------------------------------
*      name:  <unnamed>
*       log:  /home/takeshi/ドキュメント/githubprojects/LSHTMlearningnote/backupfiles/pca.log
*  log type:  text
* opened on:  10 Apr 2019, 12:10:14

use plant, replace

summarize bm1 bm2 bm3 bm4, detail

cor bm*

// the correlation matrix is a 4 by 4 symmertric matrix, the size is determined 
// by the number of variables included.

// 4. 

drop  L2_avlink* 

cluster averagelinkage bm1 bm2 bm3 bm4, name(L2_avlink)

cluster completelinkage bm1 bm2 bm3 bm4, name(L2_complink)

cluster singlelinkage bm1 bm2 bm3 bm4, name(L2_sinlink)


cluster list L2*

cluster dendrogram L2_avlink, xlabel(, angle(90) labsize(*.75)) 

// we see that specimen no 3, 14, 6, 42, 8, 30, 17, 48, 27, 31 tend to cluster
// very soon in the hierarchical process and remain separate up until a level 
// of dissimilarity of over 100. we also see that the other branches
// of the tree have a relatively symmetric shape. 

// 5. 

drop L2sq_avlink*

cluster averagelinkage bm1 bm2 bm3 bm4, name(L2sq_avlink) measure(L2squared)


cluster dendrogram L2sq_avlink, xlabel(, angle(90) labsize(*.75)) 

drop L1_avlink*
cluster averagelinkage bm1 bm2 bm3 bm4, name(L1_avlink) measure(L1)

cluster dendrogram L1_avlink, xlabel(, angle(90) labsize(*.75)) 

// 6. 

cluster dendrogram L2_complink, xlabel(, angle(90) labsize(*.75)) 

cluster dendrogram L2_sinlink, xlabel(, angle(90) labsize(*.75)) 

// 7. 

cluster stop L2_avlink, rule(calinski)

cluster stop L2_avlink, rule(duda)

cluster generate L2_avlink_k=group(2)

table(L2_avlink_k)

// 8. 

drop kmean_bm
cluster kmeans bm1 bm2 bm3 bm4, k(2) name(kmean_bm) L2

tab L2_avlink_k kmean_bm 


// 9. 

use plant1, replace

brow 

cluster averagelinkage bm1 bm2 bm3 bm4, name(L2_avlink)
cluster dendrogram L2_avlink, labels(labtech) xlabel(, angle(90) labsize(*.75)) 


sum bm* if labtech == "Sam"

sum bm* if labtech != "Sam"


cluster generate L2_avlink_k=group(2)

tab L2_avlink_k labtech

// 10. 

pca bm1 bm2 bm3 bm4, cor

// there are 4 principal components extracted from the correlation matrix 
// explaining respectively 57%, 20%, 13%, and 10% of the total system 
// variability. The first two component explain together 77% of the total, 
// the first 3 explain together 90% of the total. 

* Y1 = 0.53X1 + 0.52X2 + 0.55X3 + 0.38X4
* Y2 = -0.35X1 - 0.07X2 - 0.22X3 + 0.91X4
* Y3 = 0.34X1 - 0.85X2 + 0.36X3 + 0.15X4
* Y4 = 0.69X1 - 0.01X2 - 0.72X3 + 0.09X4

// 11. 

screeplot

// 12


// 13. 

pca bm1 bm2 bm3 bm4, cov

// 14. 

// 15. 

