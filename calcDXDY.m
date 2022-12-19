function Data = calcDXDY(Data, vecPosMat,window)
% We'll use it only on new Data that still hasn't been calculated for all
% the necessary things.
timedots=50;
telsBefore =0;

for jj = 1 : length(Data)
    % choose the 5 closest pairs.
%     V = squareform(pdist(Data(jj).initialP)) ;
%     V = V - triu(V) ; % just to eliminate double
%     V(V == 0) = 200 ; % to be above any typical distance between pairs.
%     %  SOME ALGORITHM OF FINDING THE CLOSEST 5 PAIRS.
%     PairP = zeros(5, 2) ; % the vector of the minimum-distanced pairs positions
%     for m = 1 : 5
%         [i, j] = find(V == min(min(V))) ;
%         PairP(m, :) = [i, j] ;
%         V(i, j) = 20 ;
%     end
    % calculate their correlation coefficient
    % uploading pccX (after I fix it to what Yuval offered.)
    % Basically we do cross corelation (cc) of dx (for example) of tel 1 with
    % dx of tel 2. the we arrange this vector somehow of the values of cc ( I
    % think of making it a matrix) and then making a dendrogram out of it.
%     window = 15 ;
    
    Data(jj).vecPosMat = vecPosMat(telsBefore+1:telsBefore+Data(jj).telnum,:) ;
    telsBefore = telsBefore+Data(jj).telnum ;
    Data(jj).DX15 = zeros(1, Data(jj).telnum*(timedots - window)) ; % because as we go up with dt we have less r(dt)
    
    ncz = ones(1, timedots-1) ;
    % Create dx vectors for each telomere:
    for i = 1 : Data(jj).telnum
        for dt = 1 : timedots-1
            for m = 1 : timedots-window
                Data(jj).DX15(ncz(dt)) = Data(jj).vecPosMat{i, m+window}(1) - Data(jj).vecPosMat{i, window}(1) ;
                ncz(dt) = ncz(dt) + 1 ;
            end
        end
    end
    
    for telN = 1 : Data(jj).telnum
        Data(jj).DX15mat(telN, :) = Data(jj).DX15((telN-1)*(timedots-window)+1 : telN*(timedots-window)) ;
    end
    
    %%% Creating pccY %%%
    Data(jj).DY15 = zeros(1, Data(jj).telnum*(timedots - window)) ; % because as we go up with dt we have less r(dt)
    
    ncz = ones(1, timedots-1) ;
    % Create dx vectors for each telomere:
    for i = 1 : Data(jj).telnum
        for dt = 1 : timedots-1
            for m = 1 : timedots-window
                Data(jj).DY15(ncz(dt)) = Data(jj).vecPosMat{i, m+window}(2) - Data(jj).vecPosMat{i, window}(2) ;
                ncz(dt) = ncz(dt) + 1 ;
            end
        end
    end
    
    for telN = 1 : Data(jj).telnum
        Data(jj).DY15mat(telN, :) = Data(jj).DY15((telN-1)*(timedots-window)+1 : telN*(timedots-window)) ;
    end
end
