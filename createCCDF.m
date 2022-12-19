function [jumpSizeVec, CCDF,R] = createCCDF(chosenDT, Data, WoOrder)
%%%-------- Cummulative distribution function: --------%%%
R = WoOrder(chosenDT).R;
jumpSizeVec = linspace(0, max(R)) ;
CCDF = zeros(1, length(jumpSizeVec)) ;
for i = 1 : length(CCDF)
    CCDF(i) = sum(R > jumpSizeVec(i)) ;
end

CCDF = CCDF./length(R) ;