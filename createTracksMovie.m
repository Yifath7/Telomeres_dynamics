function createTracksMovie(Data, telnumTot, timedots)
%% Movies of the tracks:
% If we deal with one file, we do it.
c = colormap(jet(timedots-1)) ;
g = colormap(jet(timedots-1)) ;
if length(Data) == 1
    xPos = zeros(timedots,telnumTot) ; % rows as timedots, each column is a new tel.
    yPos = zeros(timedots,telnumTot) ;
    zPos = zeros(timedots,telnumTot) ;
    xx = 1;
    
    for nt = 1 : Data.telnum
        dt = 1 ;
        xPos(:, nt) = Data.Positions(xx:xx+timedots-1, 2) ;  % PROBLEM WITH I AND J, IT'S NOT THE DATA INDICES SOMEHOW
        yPos(:, nt) =Data.Positions(xx:xx+timedots-1, 3) ;
        zPos(:, nt) =Data.Positions(xx:xx+timedots-1, 4) ;
        xx = xx+timedots ;
    end
    
    
    % plotting the tracks:
      
    count = 0 ;
    for ts = 1 : timedots-1 % time steps
        for nt = 1 : telnumTot % number of tels
            % If we want to draw the tracks, just delete the % in the next line.
            h = plot(xPos(ts:ts+1, nt), yPos(ts:ts+1, nt)', 'LineWidth', 1.5, 'Color',c(ts,:)') ;
%             if nt == 17 || nt == 6
%                 h = plot(xPos(ts:ts+1, nt), yPos(ts:ts+1, nt)', 'LineWidth', 3, 'Color',c(ts,:)') ;
%             elseif nt == 14 || nt == 9
%                 h = plot(xPos(ts:ts+1, nt), yPos(ts:ts+1, nt)', 'LineWidth', 3, 'Color',c(ts,:)') ;
%             end
            hold on
            if ts == 1
                text(xPos(1,nt)+0.005,yPos(1,nt)+0.005,num2str(nt),'FontSize',12, 'Color', 'k');
            end
%             xlim([-10 15])
%             ylim([-8 8])
        end
        %          h = plot(xPos(ts:ts+1, 3), yPos(ts:ts+1, 3)','r-', 'LineWidth', 1) ;
        %         hold on
        %         h = plot(xPos(ts:ts+1, 16), yPos(ts:ts+1, 16)','b-', 'LineWidth', 1) ;
        s(ts) = getframe ;
        %         text(0.3,-3,num2str(dt-1),'FontSize',12, 'Color', 'w') % to delete the older one.
        %         text(0.3,-3,num2str(dt),'FontSize',12)
        %         dt=dt+1 ;
        pause(0.02)
    end
    grid on
    title(Data.Name)
     tifName = [Data.Name(1:end-4), '.tif'];
     figName = [Data.Name(1:end-4), '.fig'];
     cur_dir = pwd ;
     cd('./Output Figures/Movies') ;
     saveas(gcf,tifName) ;
     saveas(gcf,figName) ;
     cd(cur_dir) ;
     close all
end