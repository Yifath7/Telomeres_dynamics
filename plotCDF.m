function plotCDF(CDFl, CDFwl, jumpSizeVecl, jumpSizeVecwl, chosenDT)
figure() ;
plot(jumpSizeVecl, CDFl, 'b', 'LineWidth', 2) ;
hold on
plot(jumpSizeVecwl, CDFwl, 'r', 'LineWidth', 2) ;
ylim([0 1.05])
set(gca, 'FontSize', 16)
title(['Cummulative distribution function, \Deltat = ' num2str(chosenDT)])
% xlabel('Max jump size [\mum]') ;
legend('lmna^{+/+}', 'lmna^{-/-}', 'Best') ;
xlim([0 5]) ;
xlabel('Jump size [\mum]') ;
title(['CCDF, \Deltat = ', num2str(chosenDT)]);

cur_dir = pwd ;
cd('.\Output Figures\CCDF') ;
saveas(gcf, ['CCDF dt = ', num2str(chosenDT), '.tif']) ;
cd(cur_dir) ;

