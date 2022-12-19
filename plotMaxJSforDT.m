function plotMaxJSforDT(percent)
% % JS = Jump size
% cur_dir = pwd ;
% cd('C:\Users\user\Dropbox\GariniLab\Diffusion files\All Data Files') ;
% load WoOrderWL ;
% WoOrderWL = WoOrder ;
% load WoOrderL
% WoOrderL = WoOrder ;
% cd(cur_dir) ;
% 
% maxJSL = zeros(1, 35) ; % length dt wanted
% maxJSWL = zeros(1, 35) ; 
% 
% parfor dt = 1 : 35
%     tempL = sort(WoOrderL(dt).Rsquare) ;
%     tempWL = sort(WoOrderWL(dt).Rsquare) ;
%     maxJSL(dt) = tempL(round(length(tempL)*percent)) ;
%     maxJSWL(dt) = tempWL(round(length(tempWL)*percent)) ;
% end
% 
% plot(1 : 35, maxJSL, '.-', 'linewidth', 2) ;
% hold on ;
% plot(1 : 35, maxJSWL, '.-', 'linewidth', 2) ;
% legend('lmna^{+/+}', 'lmna^{-/-}')
% xlabel('\Deltat') ;
% ylabel('Max jump [\mum]') ;
% title( ['Max jump for ', num2str(percent*100), '%']) ;
% set(gca, 'FontSize', 14)
% cur_dir = pwd ;
% cd('C:\Users\user\Dropbox\GariniLab\Diffusion files\Trying to put in functions\Output Figures\CDF')
% saveas(gcf, ['MaxJS per= ' num2str(percent) '.tif']) ;
% cd(cur_dir) ;