function [WoOrder, vecPosMat] = createNoOrder(timedots, vecPosMat, Data, filesNum)
%% Putting in the matrix without the order:
% We call it WO.
% i = 1 : timepoints
% j - running index for r^2

switch nargin
    case 4
        telnumEach = [Data(:).telnum] ;
        telnumBefore = sum(telnumEach(1 : filesNum-1)) ; 
        vecPosMat = vecPosMat(telnumBefore+1 : telnumBefore+Data(filesNum).telnum, :) ;
        telnumTot = length(vecPosMat(:, 1)) ;
    case 3 % case we want the whole vecPosMat
        telnumTot = length(vecPosMat(:, 1)) ;
end
% timedots = length(vecPosMat(1, :)) ;
% timedots = 50;
% Some kind of prellocating our WithoutOrder structure:
vecPosMat=vecPosMat(:,1:timedots);
for dt = 1 : timedots-1
    WoOrder(dt).Rsquare = zeros(1, telnumTot*(timedots - dt)) ; % because as we go up with dt we have less r(dt)
    WoOrder(dt).R = zeros(1, telnumTot*(timedots - dt)) ;
     WoOrder(dt).theta = zeros(1, telnumTot*(timedots - dt)) ;
end

ncz = ones(1, timedots-1) ;
for i = 1 : telnumTot
    for dt = 1 : timedots-1
        for m = 1 : timedots-dt
            WoOrder(dt).Rsquare(ncz(dt)) = sum((vecPosMat{i, m+dt} - vecPosMat{i, m}).^2) ; % Calculating R square for each dt
            WoOrder(dt).R(ncz(dt)) = sqrt(sum((vecPosMat{i, m+dt} - vecPosMat{i, m}).^2)) ;
            WoOrder(dt).theta(ncz(dt)) = atan((vecPosMat{i, m+dt}(2) - vecPosMat{i, m}(2))/...
                (vecPosMat{i, m+dt}(1) - vecPosMat{i, m}(1))) ;
            WoOrder(dt).X(ncz(dt)) = vecPosMat{i, m+dt}(1) - vecPosMat{i, m}(1) ;
            WoOrder(dt).Y(ncz(dt)) = vecPosMat{i, m+dt}(2) - vecPosMat{i, m}(2) ;
            ncz(dt) = ncz(dt) + 1 ;
        end
    end
end