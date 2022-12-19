function newCalcCorr(Data,vecPosMat)
window = 15 ;

Data = calcDXDY(Data, vecPosMat,window) ;

for cell = 1 : length(Data)
    [~, cell_name, ~] = fileparts(Data(cell).Name);
    %%% Calculation of sqrt(Edx1^2*Edx2^2):
    dxSum= sqrt(sum(Data(cell).DX15mat.^2, 2)) ;
    Cmat=dxSum*dxSum';
    
    %%% Calculation od the average distance beween two telomeres along the
    %%% trajectory:
    disMat=zeros(Data(cell).telnum) ;
    
    for i = 1 : Data(cell).telnum
        for j = 1 : Data(cell).telnum
            for t = 1 : 50
                disMat(i,j) = disMat(i,j)+norm((vecPosMat{i,t}- vecPosMat{j,t})) ;
            end
        end
    end
    disMat=disMat/50 ;
    
    %%% Calculation and Presenetation of the actual cc:
    DX=Data(cell).DX15mat';
    multDX=DX'*DX;
    
    DXcorr=multDX./Cmat;
    disMat(1:Data(cell).telnum+1:end) = inf;
    DXcorr_withDis = DXcorr./disMat;
    DXcorr_withDis = DXcorr_withDis/max(DXcorr_withDis(:));
    DXcorr_withDis(1:Data(cell).telnum+1:end)=1;
    
    %%% Regular
    imagesc(tril(DXcorr))
    colormap('redblue')
    set(gca, 'clim', [-1,1]) ;
    title('Heat map of correlation coefficient, x axis') ;
    colorbar;
    cur_dir=pwd;
    cd('.\Output Figures\Corrs')
    saveas(gcf, ['finCorrDT ' num2str(window),' ', cell_name,'.tif']) ;
    cd(cur_dir)
    % saveas()
    
    DXcorr02=DXcorr ;
    DXcorr02(DXcorr<0.2)= 0 ;
    imagesc(tril(DXcorr02))
    colormap('redblue')
    set(gca, 'clim', [-1,1]) ;
    title('Heat map of correlation coefficient, x axis above 0.2') ;
    colorbar;
    cd('.\Output Figures\Corrs')
     saveas(gcf, ['finCorr02DT ' num2str(window),' ', cell_name,'.tif']) ;
    cd(cur_dir)
    % saveas()
    
    DXcorr05=DXcorr ;
    DXcorr05(DXcorr<0.5)=0 ;
    imagesc(tril(DXcorr05))
    colormap('redblue')
    set(gca, 'clim', [-1,1]) ;
    title('Heat map of correlation coefficient, x axis above o.5') ;
    colorbar;
    cd('.\Output Figures\Corrs')
    saveas(gcf, ['finCorr05DT ' num2str(window),' ', cell_name,'.tif']) ;
    cd(cur_dir)
    % saveas()
    
    %%% With distance
    imagesc(tril(DXcorr_withDis))
    colormap('redblue')
    set(gca, 'clim', [-1,1]) ;
    title('Distance-weighed correlation coefficient, x axis') ;
    colorbar;
    cd('.\Output Figures\Corrs')
    saveas(gcf, ['finCorrDisDT ' num2str(window),' ', cell_name,'.tif']) ;
    cd(cur_dir)
    % saveas()
    
    DXcorr_withDis02=DXcorr_withDis ;
    DXcorr_withDis02(DXcorr_withDis<0.2)=0 ;
    imagesc(tril(DXcorr_withDis02))
    colormap('redblue')
    set(gca, 'clim', [-1,1]) ;
    title('Distance-weighed correlation coefficient, x axis above 0.2') ;
    colorbar;
    cd('.\Output Figures\Corrs')
    saveas(gcf, ['finCorrDis02DT ' num2str(window),' ', cell_name,'.tif']) ;
    cd(cur_dir)
    % saveas()
    
    DXcorr_withDis05=DXcorr_withDis ;
    DXcorr_withDis05(DXcorr_withDis<0.5)=0 ;
    imagesc(tril(DXcorr_withDis05))
    colormap('redblue')
    set(gca, 'clim', [-1,1]) ;
    title('Distance-weighed correlation coefficient, x axis above 0.5') ;
    colorbar;
    cd('.\Output Figures\Corrs')
    saveas(gcf, ['finCorrDis05DT ' num2str(window),' ', cell_name,'.tif']) ;
    cd(cur_dir)
    % saveas()
    close all
    
    %% I need to add Y axis to DX
%     dySum= sqrt(sum(Data(cell).DY15mat.^2, 2)) ;
%     Cymat=dySum*dySum';
%     
%     DY=Data(cell).DY15mat';
%     multDY=DY'*DY;
%     
%     DYcorr=multDY./Cymat;
%     disMat(1:Data(cell).telnum+1:end) = inf;
%     DYcorr_withDis = DYcorr./disMat;
%     DYcorr_withDis = DYcorr_withDis/max(DYcorr_withDis(:));
%     DYcorr_withDis(1:Data(cell).telnum+1:end)=1;
%     
%     
%     DYcorr_withDis05=DYcorr_withDis ;
%     DYcorr_withDis05(DYcorr_withDis<0.5)=0 ;
%     imagesc(0.5*(DYcorr_withDis05.*DXcorr_withDis05))
%     colormap('redblue')
%     set(gca, 'clim', [-1,1]) ;
%     title('Distance-weighed correlation coefficient, average of x and y above 0.5') ;
%     colorbar;
%     cd('.\Output Figures\Corrs')
%     saveas(gcf, ['mean(XY) corr05 ' num2str(window),' ', cell_name,'.tif']) ;
%     cd(cur_dir)
%     % saveas()
%     close all
%     
%     
%     
 end