function loadFunc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                               Yifat Haddad                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear ;
% close all ;
prompt = 'Enter #timedots' ;
title = 'Input' ;
num_lines = 1 ;
def = {'50'} ;
timedots = inputdlg(prompt, title, num_lines, def);
timedots = str2double(timedots) ;
[Data, vecPosMat, button] = initialLoad(timedots) ;


switch button
    case 'No'
        [WoOrder, ~] = createNoOrder(timedots, vecPosMat, Data) ;
        telnumTot = sum([Data(:).telnum]) ;
        choice1 = questdlg('What would you like to do?', ':)', ...
            'Create time-window graphs','Create trajectory movies'...
            ,'Create dendrogarm plot','Create dendrogarm plot');
        
        switch choice1
            case 'Create time-window graphs'
                % for each telomere create the size of R graph for
                % different time windows.
                createRvsRealTime_diffD(Data, WoOrder, telnumTot, timedots) ;
                
            case 'Create trajectory movies'
                createTracksMovie(Data, telnumTot, timedots) ;
                
            case 'Create dendrogarm plot'
                % case dendrogram and heatmap r&b:
                axes1 = createDendrogram(vecPosMat, Data) ;
                prompt = 'Enter wanted time-window dt' ;
                title = 'Input' ;
                num_lines = 1 ;
                def = {'16'} ;
                dt = inputdlg(prompt, title, num_lines, def);
                dt = str2double(dt) ;
                jumpsMap(Data, dt, timedots, WoOrder, telnumTot, axes1) ;
            case 'Create' 
                d=0
                
        end
        
        
    case 'Yes'
        choice2 = questdlg('Would you like to analyze each file seperatley?', ':)', ...
            'Yes','No', 'No');
        
        switch choice2
            case 'Yes'
                vecPosMat_init = vecPosMat ;
                for filesNum = 1 : length(Data)
                    [WoOrder, vecPosMat] = createNoOrder(timedots, vecPosMat_init, Data, filesNum) ;
                    telnumTot = Data(filesNum).telnum ;
                    
                    if filesNum == 1
                        choice3 = questdlg('What would you like to do?', ':)', ...
                            'Create trajectory movies', 'None', 'Create dendrogarm plot',...
                            'Create dendrogarm plot');
                    end
                    
                    switch choice3
                        case 'Create trajectory movies'
                            createTracksMovie(Data(filesNum), telnumTot, timedots) ;
                            
                        case 'Create dendrogarm plot'
                            % case dendrogram and heatmap r&b:
                            axes1 = createDendrogram(vecPosMat, Data(filesNum)) ;
                            if filesNum == 1
                                prompt = 'Enter wanted time-window dt' ;
                                title = 'Input' ;
                                num_lines = 1 ;
                                def = {'16'} ;
                                dt = inputdlg(prompt, title, num_lines, def);
                                dt = str2double(dt) ;
                                
                            end
                            jumpsMap(Data(filesNum), dt, timedots, WoOrder, telnumTot, axes1) ;
                            
                        case 'None'
                            Data(filesNum).WoOrder = WoOrder ;
                    end
                end
                a=3;
                
            case 'No'
                [WoOrder, ~] = createNoOrder(timedots, vecPosMat, Data) ;
                %                 telnumTot = sum([Data(:).telnum]) ;
                choice4 = questdlg('What would you like to do?', ':)', ...
                    'Create Poincare maps', 'Create a heat map', 'All Data', 'Create heat map');
                
                switch choice4
                    % CASE MANY DATA:
                    case 'Create Poincare maps'
                        % case Poincare:
                        % WATNING: only 100 tp.
                        warndlg('At the moment, the function is defined for 100 tp only.','Warning')
                        createPoincareMap(Data, WoOrder) ;
                        
                    case 'Create a heat map'
                        % case HeatMap:
                        createHeatMap(WoOrder) ;
                        
                    case 'All Data'
                        cur_dir = pwd ;
                        %                         cd('..\All Data Files') ;
                        %                         load('DataLMNA.mat') ;
                        %                         load ('DataWL.mat') ;
                        %                         cd(cur_dir) ;
                        load('forHMminus.mat') ;
                        DataWL = Data ;
                        WoOrderWL = WoOrder ;
                        load('forHMplus.mat') ;
                        %                         chosenDT = inputdlg('Enter dt: ', 'CDF') ;
                        %                         chosenDT = str2double(chosenDT{1}) ;
                        chosenDT = input('Enter dt series:') ;
                        
                        for dt = 1 : length(chosenDT)
                            [jumpSizeVecl, CCDFl] = createCCDF(chosenDT(dt), Data,WoOrder) ;
                            [jumpSizeVecwl, CCDFwl] = createCCDF(chosenDT(dt), DataWL, WoOrderWL) ;
                            plotCDF(CCDFl, CCDFwl, jumpSizeVecl, jumpSizeVecwl, chosenDT(dt)) ;
                            %                             percent = inputdlg('Enter percent for the cdf') ;
                            %                             percent = str2double(percent{1}) ;
                            %                             plotMaxJSforDT(percent);
                        end
                        
                        
                        % make histogram of beyond expectation telomeres:
                        dt_series = input('Enter dt series:') ;
                        makeHistofBeyondExpectaiton(dt_series, Data, DataWL) ;
                        
                        % create plot of PCC vs the pairs' distance.
                        plotPCCvsD(Data, DataWL) ;
                end
        end
end
end