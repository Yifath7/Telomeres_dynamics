function plotPCCvsD(DataL, DataWL)
% This function creates a graph that shows the relation between the
% correlation coefficient and the telomeres' distnace.
LTot = sum([DataL(:).telnum]) ;
WLTot = sum([DataWL(:).telnum]) ;

Lvec = [] ;
LpVec = [] ;

% Calculate distnace matrix DataL:
for cellN = 1 : length(DataL)
    DistM = dist(DataL(cellN).initialP, DataL(cellN).initialP') ;
    DR = sqrt((DataL(cellN).DXmat).^2 + (DataL(cellN).DYmat).^2);
    pccR = corr(DR') ;
    pccR(pccR == 1)=0;
    DMV = squareform(DistM, 'tovector') ;
    PCV = squareform(pccR, 'tovector') ;
    
    Lvec = cat(2, Lvec, DMV) ;
    LpVec = cat(2, LpVec, PCV) ;
end

figure ;
plot(Lvec, LpVec,'.') ;



WLvec = [] ;
WLpVec = [] ;


% Calculate distnace matrix DataWL:
for cellN = 1 : length(DataWL)
    DistM = dist(DataWL(cellN).initialP, DataWL(cellN).initialP') ;
    DR = sqrt((DataWL(cellN).DXmat).^2 + (DataWL(cellN).DYmat).^2);
    pccR = corr(DR') ;
    pccR(pccR == 1)=0;
    DMV = squareform(DistM, 'tovector') ;
    PCV = squareform(pccR, 'tovector') ;
    
    WLvec = cat(2, Lvec, DMV) ;
    WLpVec = cat(2, LpVec, PCV) ;
end



% Calculate distnace matrix DataL:
% for cellN = 1 : length(DataWL)
%     DistM = dist(DataWL(cellN).initialP, DataWL(cellN).initialP') ;
%     pccR = DataWL(cellN).pccR ;
%     pccR(1:DataWL(cellN).telnum+1:end)=0;
%     DMV = squareform(DistM, 'tovector') ;
%     PCV = squareform(pccR, 'tovector') ;
%     
%     WLvec = cat(2, WLvec, DMV) ;
%     WLpVec = cat(2, WLpVec, PCV) ;
% end

figure ;
plot(WLvec, WLpVec,'.') ;


% Histogram of correlated trajectories vs the distance.
figure;
histogram(WLvec(WLpVec > 0.9))

figure;
histogram(WLvec(WLpVec < -0.5))

figure;
histogram(WLvec(WLpVec < 0.5 & WLpVec > -0.5))


histogram(WLpVec)
figure; histogram(WLpVec)
hold on

keyboard ;
