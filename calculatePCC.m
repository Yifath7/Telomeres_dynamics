function [Data] = calculatePCC(Data)
allMinPC = zeros(1,5*length(Data)) ;
for jj = 1 : length(Data)
    % choose the 5 closest pairs.
    V = squareform(pdist(Data(jj).initialP)) ;
    V = V - triu(V) ; % just to eliminate double
    V(V == 0) = 200 ; % to be above any typical distance between pairs.
    %  SOME ALGORITHM OF FINDING THE CLOSEST 5 PAIRS.
    PairP = zeros(5, 2) ; % the vector of the minimum-distanced pairs positions
    for m = 1 : 5
        [i, j] = find(V == min(min(V))) ;
        PairP(m, :) = [i, j] ;
        V(i, j) = 20 ;
    end
    % calculate their correlation coefficient
    % uploading pccX (after I fix it to what Yuval offered.)
    % Basically we do cross corelation (cc) of dx (for example) of tel 1 with
    % dx of tel 2. the we arrange this vector somehow of the values of cc ( I
    % think of making it a matrix) and then making a dendrogram out of it.
    window = 1 ;
    
    Data(jj).DX = zeros(1, Data(jj).telnum*(timedots - window)) ; % because as we go up with dt we have less r(dt)
    
    ncz = ones(1, timedots-1) ;
    % Create dx vectors for each telomere:
    for i = 1 : Data(jj).telnum
        for dt = 1 : timedots-1
            for m = 1 : timedots-window
                Data(jj).DX(ncz(dt)) = Data(jj).vecPosMat{i, m+window}(1) - Data(jj).vecPosMat{i, window}(1) ;
                ncz(dt) = ncz(dt) + 1 ;
            end
        end
    end
    
    for telN = 1 : Data(jj).telnum
        Data(jj).DXmat(telN, :) = Data(jj).DX((telN-1)*(timedots-window)+1 : telN*(timedots-window)) ;
    end
    
    % use transpose to create two matrices in order to calculate the
    % correlation and then multiply
    Data(jj).pccX = Data(jj).DXmat*Data(jj).DXmat' ;
    % create the C matrix.
    Data(jj).DXsum = sqrt(sum(Data(jj).DXmat.^2, 2)) ;
    Data(jj).Cmat = Data(jj).DXsum*Data(jj).DXsum' ;
    % divide element by element.
    Data(jj).pccX = Data(jj).pccX ./ Data(jj).Cmat ;
    
    %%% Creating pccY %%%
    Data(jj).DY = zeros(1, Data(jj).telnum*(timedots - window)) ; % because as we go up with dt we have less r(dt)
    
    ncz = ones(1, timedots-1) ;
    % Create dx vectors for each telomere:
    for i = 1 : Data(jj).telnum
        for dt = 1 : timedots-1
            for m = 1 : timedots-window
                Data(jj).DY(ncz(dt)) = Data(jj).vecPosMat{i, m+window}(2) - Data(jj).vecPosMat{i, window}(2) ;
                ncz(dt) = ncz(dt) + 1 ;
            end
        end
    end
    
    for telN = 1 : Data(jj).telnum
        Data(jj).DYmat(telN, :) = Data(jj).DY((telN-1)*(timedots-window)+1 : telN*(timedots-window)) ;
    end
    
    % use transpose to create two matrices in order to calculate the
    % correlation and then multiply
    Data(jj).pccY = Data(jj).DYmat*Data(jj).DYmat' ;
    % create the C matrix.
    Data(jj).DYsum = sqrt(sum(Data(jj).DYmat.^2, 2)) ;
    Data(jj).Cmat = Data(jj).DYsum*Data(jj).DYsum' ;
    % divide element by element.
    Data(jj).pccY = Data(jj).pccY ./ Data(jj).Cmat ;
    %%%%%%
    
    %%% pccR %%%
    %     Data(jj).DRmat = Data(jj).DXmat+Data(jj).DYmat ;
    %
    %     % Creating the C:
    %     Data(jj).pccR = Data(jj).DRmat*Data(jj).DRmat' ;
    %
    %     % create the C matrix.
    %     c = sqrt(sum(Data(jj).DRmat.^2, 2)) ;
    %     Data(jj).Cmat = c*c' ;
    %     % divide element by element.
    %     Data(jj).pccR = Data(jj).pccR ./ Data(jj).Cmat ;
    %%%%%%
    
    Data(jj).pccR = (Data(jj).pccX+Data(jj).pccY)./2;
    PairP = (PairP(:,2)-1)*length(PairP) + PairP(:,1) ;
    minPC = Data(jj).pccR(PairP) ;
    
    % repeat for many cells.
    allMinPC(5*jj-4 : 5*jj) = minPC' ;
    
    
    
end