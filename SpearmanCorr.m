function SpearmanCorr(Data)
% This function calculates spearmans correlation and plots the heatmaps
% with the sc for every telomere pair.
cur_dir = pwd ; 
cd('C:\Users\user\Dropbox\GariniLab\Diffusion files\Trying to put in functions\Output Figures\Sp vs PCC') ;
diffC = [] ;
for cellN = 1 : length(Data)
    %     DistM = dist(Data(cellN).initialP, Data(cellN).initialP') ;
    DR5 = sqrt((Data(cellN).DX5mat).^2 + (Data(cellN).DY5mat).^2);
    sRankC = corr(DR5', 'type', 'spearman') ;
    PCC = corr(DR5') ;
    
        figure ;
        imagesc(sRankC) ;
        title(['\Deltat=5 Spearmans Correlation Heatmap cell ' num2str(cellN)]) ;
        colorbar;
        cd(cur_dir) ;
        colormap(redblue) ;
        cd('C:\Users\user\Dropbox\GariniLab\Diffusion files\Trying to put in functions\Output Figures\Sp vs PCC') ;
        set(gca, 'Clim', [-1 1], 'FontSize', 14) ;
        saveas(gca, ['Sp5 ' num2str(cellN), '.tif']) ;
    
        figure ;
        imagesc(PCC) ;
        title(['\Deltat=5 Pearson Correlation Heatmap cell ' num2str(cellN)]) ;
        colorbar;
        cd(cur_dir) ;
        colormap(redblue) ;
        cd('C:\Users\user\Dropbox\GariniLab\Diffusion files\Trying to put in functions\Output Figures\Sp vs PCC') ;
        set(gca, 'Clim', [-1 1], 'FontSize', 14) ;
        saveas(gca, ['Per5 ' num2str(cellN) '.tif']) ;
    
    diffC = cat(1, diffC, PCC(:)-sRankC(:)) ;
    
%     sRankC(sRankC == 1)=0;
%         SCV = squareform(sRankC, 'tovector') ;
%     figure(cellN) ;
%     bar(abs(PCC(:)-sRankC(:)));
%     title(['Difference between the correlation coefficients, cell ', num2str(cellN)]) ;
end


hist(diffC,30);
title('Difference between the correlation coefficients \Deltat=5, all cells') ;
cd(cur_dir) ;