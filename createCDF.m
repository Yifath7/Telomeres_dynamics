function [jumpSizeVec, CDF,R] = createCDF(chosenDT, Data)
%%%-------- Cummulative distribution function: --------%%%
% We need to extract the Rsquare value from Data(#file).WoOrder(#dt).Rsquare
Rsquare = [] ;
for jj = 1 : length(Data)
    Rsquare(end+1 : end+length(Data(jj).WoOrder(chosenDT).Rsquare))...
        = Data(jj).WoOrder(chosenDT).Rsquare ;
end
R = sqrt(Rsquare) ;
jumpSizeVec = linspace(0, max(R)) ;
CDF = zeros(1, length(jumpSizeVec)) ;
for i = 1 : length(CDF)
    CDF(i) = sum(R <= jumpSizeVec(i)) ;
end

CDF = CDF./length(R) ;
