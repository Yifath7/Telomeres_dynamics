function jumpsMap(Data, dt, timedots, WoOrder, wantedTelN, axes1)
%% Displaying Rmax as a Heat Map in a certain dt:
% we need first to make a matrix that collects all the R variables for each
% telomere in a certain dt.
% wantedTelN = telnumTot;
dtN = timedots - dt ;
R = zeros(wantedTelN, dtN) ;
% for DT = 1 : 2
%     Dc(DT) = mean(WoOrder(DT).Rsquare)./(4*DT) ;
% end
% Dcoef = mean(Dc);
% sigma = 2*sqrt(Dcoef*dt) ;
load ('sigmaA_WL.mat') ;
for telN =  1 : wantedTelN
    R(telN, :)= sqrt(WoOrder(dt).Rsquare((telN-1)*dtN+1 : telN*dtN))- 1.5*sigmaWL(dt);
end
R_above_num = sum(R>0) ;
R(R<0) = 0;
%% Sorting R matrix to diagonal shape.
% sRv = zeros(telnumTot, 2) ;
% for i = 1 : telnumTot
%     j = 1 ;
%     while j <= timedots - dt
%         if R(i, j) >= 0.2
%             sRv(i, :) = [j, R(i,j)] ;
%             break
%         end
%         j = j + 1 ;
%     end
% end
% sRv(:,end+1) = 1 : telnumTot ;
% sRv = sortrows(sRv,2) ;
% sRv = sortrows(sRv,1) ;
% 
% while sRv(1,1) == 0
%     sRv(end+1,:) = sRv(1, :) ;
%     sRv(1, :) = [];
% end
% axes3 = sRv(:,3) ; % I HAVE NO IDEA WHAT AXES3 IS!!
%%
% now we need to sort by te numbers of the dendrogram.
R = R(axes1(end:-1:1), :) ; % problem with pcolor because in needs more than a vector to plot.
% R = R(sRv(:,3), :) ;
figure();
imagesc(R)
colormap redblue
colorbar;
upperLim = 1 ;
set(gca, 'Clim', [0, 1]) ;
axis off
% p2 = get(s2, 'pos') ;
% p2(1) = p2(1)-0.03 ; % move in x
% p2(3) = p2(3)+0.04 % width
% p2(2) = p2(2) +0.01;
% p2(4) = p2(4) +0.005;
% p2(1) = 0.5103 ;
% p2(2) = 0.07 ;
% p2(3) = 0.3623 ;
% p2(4) = 0.82 ;
% set(s2, 'pos', p2) ;
% p2 = 0.5103 0.11 0.3623 0.815
set(gca,'FontSize',14)
title([Data.Name(1:end-9), [', \Deltat=',num2str(dt)]])

%%% Save figure %%%
cd('.\Output Figures\Dendrograms') ;
% cd('D:\Dropbox\GariniLab\Diffusion files\Trying to put in functions\Output Figures\Dendrograms') ;
saveas(gcf, [Data.Name(1:end-9), [' Dt=',num2str(dt),' upperLim=',...
    num2str(upperLim)], ' JumpsMap.tif']) ;
cd('..\..\') ;
% cd('D:\Dropbox\GariniLab\Diffusion files\Trying to put in functions') ;