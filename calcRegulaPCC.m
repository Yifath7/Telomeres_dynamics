function Data = calcRegulaPCC(Data)
%{ 
This function uses the matlab command "corr" to calculate
the correlation coefficient between pairs.

DON'T FORGET:
calculatePCC stil exists - 
uses my wierd way of calculating correlation.
%}

% Calculate distnace matrix DataL:
for cellN = 1 : length(DataL)
    DistM = dist(DataL(cellN).initialP, DataL(cellN).initialP') ;
    DR = sqrt((DataL(cellN).DXmat).^2 + (DataL(cellN).DYmat).^2);
    pccR = corr(DR') ;
    pccR(pccR == 1)=0;
    DMV = squareform(DistM, 'tovector') ;
    PCV = squareform(pccR, 'tovector') ;
end
