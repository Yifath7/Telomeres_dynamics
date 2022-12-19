function createDarray(timedots,WoOrder)
	% Just a fun function to create Dc for all dt and for ++ or --. assuming we enter with all data ++

	Dc = zeros(1, timedots) ;
for DT = 1 : timedots-1
    Dc(DT) = mean(WoOrder(DT).Rsquare)./(4*DT) ;
end

save('Dcoef_minus.mat', 'Dc')