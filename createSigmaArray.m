function createSigmaArray(WoOrder, timedots)
	% This function is here to try and replace the sigma calculation with D

	sigmaWL = zeros(1, timedots-1);

	for DT = 1 : timedots-1
    	sigmaWL(DT) = std(sqrt(WoOrder(DT).Rsquare)) ;
	end

	save('sigmaA_WL.mat', 'sigmaWL')