%{ 
We need to make Dc for all DT,
and then for the corresponding
DT choose it. 
%}

function createRvsRealTime_diffD(Data, WoOrder, telnumTot, timedots)
wantedTelN = telnumTot ; % how many tels we want to see the track
% Different threshold for every dt, using Dcoef estimation.

% We take Dcoef to be te average between the first and second D (from dt=1
% and 2)

load('Dcoef_minus.mat');

str = {'Smooth', 'Not smooth'};
[s,~] = listdlg('PromptString','Select: ',...
    'SelectionMode','single',...
    'ListString',str, 'ListSize', [160,80]) ;
for telN =  1 : wantedTelN % for convinience in figures order
    figure(telN)
    S = 0.0; % the wanted space.
    space = 0 ; % the initial space, 0 of course
    leg ='' ; % the legend string
    %     leg2 = ''; % the 'Peaks in' string
    
    %     jump = 3 ;
    % threshold = 2sigma = 4 sqrt(Dc*dt)
    load sigmaA_WL
%     sigmaWL=sigmaL;
    for dt = [5 10 15]
%     	Dcoef = Dc(dt);
        dtN = timedots-dt ;
        % NOW IT'S ZERO BECAUSE I WANT THE ACTUAL VALUE
        sigma = 1*sigmaWL(dt) ;
        R = sqrt(WoOrder(dt).Rsquare((telN-1)*dtN+1 : telN*dtN)) - sigma ;
        R(R<0) = 0 ;
        R = R + space ;
        telN
        dt
        disp('max val is')
        max(R)
        
        if s == 1
            plot(1+0.5*dt : dtN+0.5*dt, smooth(R,0.1,'loess'))
        else
            plot(1+0.5*dt : dtN+0.5*dt, R)
        end
        fp=[];
        % The explanation for the expression inside the WoOrder.Rsquare is in
        % my NB p70.
        hold on
        space = space + S ;
        leg{end+1} = ['\Deltat=', num2str(dt)] ; % the legend string
        if  isempty(fp) == 0
            leg{end+1} =[ 'Peaks in ', num2str(dt) ] ; % If there are peaks.
        end
        %         dtN = dtN-jump ; % as we go further, the number of data we have decreases.
    end
    hold off
    legend(leg, 'Location', 'BestOutSide')
    title(['|R| in real time, telomer ' num2str(telN) ' ' Data.Name(6 : end)]) % In files of 100 points,1
    % the name of the file is "n-nD LMNA" so we need from th 6th letter to
    % the end to display whether the tel is from woL or L.
    xlabel('t')
    ylabel('R [\mum]')
    ylim([0, 1])
    %     text(2, 1, ['space = ', num2str(S)], 'FontSize', 12, 'FontWeight', 'Bold')
    set(gca,'FontSize',18)
    grid on
    cur_dir = pwd ;
    [~, cell_name, ~] = fileparts(Data.Name) ;
    mkdir(['.\Output Figures\RvsTime_diffD_newSigma\'...
        , cell_name, 'lim 1']) ;
    cd(['.\Output Figures\RvsTime_diffD_newSigma\'...
        , cell_name, 'lim 1']) ;
    saveas(gcf, ['3 different dts R-1.5sigma tel_NOSIGMA ' num2str(telN),' ', cell_name,'.tif']) ;
    cd(cur_dir) ;
end