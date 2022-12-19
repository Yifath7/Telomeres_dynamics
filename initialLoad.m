
function [Data, vecPosMat, button] = initialLoad(wantedTD)
%%% Yifat Haddad %%%
%{
    wantedTD - 50 or 100, usually 50.
%}
% clear ;
% close all ;

% get the file
button = questdlg('More than 1?') ;
cd('../Excell files') ; % change directory to the one with the files.
% cd('D:\Dropbox\GariniLab\Diffusion files\Excell files') ; % change directory to the one with the files.
[fileName, pathName] = uigetfile({'*.xlsx' ; '*.xls' ; '*.xml'}, 'Load data files', 'MultiSelect', 'On') ;
cd('../Trying to put in functions') ; % change back to the main folder
% cd('D:\Dropbox\GariniLab\Diffusion files\Trying to put in functions') ; % change back to the main folder
% different types of files. xlsx is organized differently. so for each type
% we need to read the file differently.
if strcmpi(button, 'No')
    if strcmpi(fileName(end-3 : end), 'xlsx') == 1
        [Position, txt] = xlsread( [pathName, fileName] ,'Spot Position') ;   % load "Spot Position" sheet of the xlsx file.
    else
        [Position, txt] = xlsread( [pathName, fileName] ,'Position') ;   % load "Position" sheet of the xls file.
    end
    Data(1).Name = fileName ;
    Data(1).Path = pathName ;
    Data(1).Positions = Position ;
    Data(1).Text = txt ;
else
    for l = 1 : length(fileName)
        if strcmpi(fileName{l}(end-3 : end), 'xlsx') == 1
            [Position, txt] = xlsread( [pathName, fileName{l}] ,'Spot Position') ;   % load "Spot Position" sheet of the xlsx file.
        else
            [Position, txt] = xlsread( [pathName, fileName{l}] ,'Position') ;   % load "Position" sheet of the xls file.
        end
        Data(l).Name = fileName{l} ;
        Data(l).Path = pathName ;
        Data(l).Positions = Position ;
        Data(l).Text = txt ;
    end
end

clear 'Position' 'pathName'

clear 'fileName' 'Positions' 'Position1' 'txt1' 'txt'

% Organizing the data:
%
% The following is just to find where are the time, x, y, z for each kind.
% this program is yet only for the same number of time points for every
% telomere.

i = length(Data)+2 ; % when I upload a data file
badData = zeros(1, i-2) ;

for j = 1 : i-2
    
    if strcmpi(Data(j).Name(end-3 : end), 'xlsx') == 1
        [~, Data(j).timeCol] = find(strcmpi('Time', Data(j).Text)) ; % finding where Time is
        Data(j).timeCol = max(Data(j).timeCol) ;
        [~, Data(j).xCol] = find(strcmpi('Average of Position X', Data(j).Text)) ; % x position
        [~, Data(j).yCol] = find(strcmpi('Average of Position Y', Data(j).Text)) ; % y position
        [~, Data(j).zCol] = find(strcmpi('Average of Position Z', Data(j).Text)) ; % z position
        
        % ** Here we delete the 'Group 2' Data because it's not a telomere.
        % also all the rest of the NaNs.
        datRemove = isnan( Data(j).Positions(: , Data(j).timeCol) ) ; % We get a vec of 0 and 1
        count = 0 ;
        for d = 1 : length(datRemove)
            count = count + (datRemove(d) == 1) ;
            if count == 5
                break
            end
        end
        Data(j).Positions(1:d, :) = [] ; % Clear Group 2
        datRemove(1:d) = [] ;
        clear 'd' 'count' ;
        
        rem = find(datRemove == 1) ;
        Data(j).Positions(rem, :) = [] ; % Clear the rest of the NaNs.
        
        % now, delete everything else that's not needed
        Data(j).Positions(:, 1:(Data(j).timeCol-1)) = [] ;
        Data(j).timeCol = 1 ;
        Data(j).xCol = 2 ;
        Data(j).yCol = 3 ;
        Data(j).zCol = 4 ;   % we have now just these four columns
        
        % finding telnum
        Data(j).telnum = length( find(Data(j).Positions(:, 1) == 1) ) ; % we get a vec with the indices of '1',
        % therefore the length of this vec is the telnum
        
        % finding number of time points:
        Data(j).timedots = max(Data(j).Positions(:, Data(j).timeCol)) ;
        
        % checking if there are timepoints missing
        if Data(j).timedots*Data(j).telnum ~=length(Data(j).Positions(:, 1)) % doesn't matter which column, they're all the same
            % warndlg('You have to delete the bad ones :( - xlsx')
            badData(j) = 1 ;
        end
        
        
    elseif strcmpi(Data(j).Name(end-2 : end), 'xls') == 1 % for xls files
        [~, Data(j).timeCol] = find(strcmpi('Time', Data(j).Text)) ;
        [~, Data(j).xCol] = find(strcmpi('Position X', Data(j).Text)) ;
        [~, Data(j).yCol] = find(strcmpi('Position Y', Data(j).Text)) ;
        [~, Data(j).zCol] = find(strcmpi('Position Z', Data(j).Text)) ;
        [~, Data(j).parentCol] = find(strcmpi('Parent', Data(j).Text)) ;
        if isempty(Data(j).parentCol)
            [~, Data(j).parentCol] = find(strcmpi('TrackID', Data(j).Text)) ;
        end
        Data(j).timedots = max(Data(j).Positions(:, Data(j).timeCol)) ;   % finding #timedots
        
        % to make it easier in the deleting etc, we'll change the format here
        % from [all telomeres in timedot1 etc] to [all timedots for
        % telomere 1 etc] with SORTROWS so it matches xlsx and xml which in this format already.
        
        Data(j).Positions = sortrows(Data(j).Positions, Data(j).parentCol) ;
        
        % finding telnum
        Data(j).telnum = length( find(Data(j).Positions(:, Data(j).timeCol) == 1) ) ; % we get a vec with the indices of '1',
        % therefore the length of this vec is the telnum
        
        Data(j).timedots = max(Data(j).Positions(:, Data(j).timeCol)) ; % finding #timedots
        
        % finding number of time points:
        Data(j).timedots = max(Data(j).Positions(:, Data(j).timeCol)) ;
        
        
        if Data(j).timedots*Data(j).telnum ~=length(Data(j).Positions(:, 1)) % doesn't matter which column, they're all the same
            warndlg('You have to delete the bad ones :( - xls')
            badData(j) = 1 ;
        end
        
    else %xml
        [~, Data(j).timeCol] = find(strcmpi('Time', Data(j).Text)) ;
        [~, Data(j).xCol] = find(strcmpi('Position X', Data(j).Text)) ;
        [~, Data(j).yCol] = find(strcmpi('Position Y', Data(j).Text)) ;
        [~, Data(j).zCol] = find(strcmpi('Position Z', Data(j).Text)) ;
        
        Data(j).Positions = Data(j).Positions(:,[Data(j).timeCol Data(j).xCol Data(j).yCol Data(j).zCol]); % to make it like in xlsx which we have 4 columns
        Data(j).timeCol = 1 ;
        Data(j).xCol = 2 ;
        Data(j).yCol = 3 ;
        Data(j).zCol = 4 ;   % we have now just these four columns
        
        Data(j).timedots = max(Data(j).Positions(:, Data(j).timeCol)) ; % finding #timedots
        
        % finding telnum
        Data(j).telnum = length( find(Data(j).Positions(:, 1) == 1) ) ;
        
        % Checking if everyone have all the time points:
        if Data(j).timedots*Data(j).telnum ~=length(Data(j).Positions(:, 1)) % doesn't matter which column, they're all the same
            warndlg('You have to delete the bad ones :( - xml')
            badData(j) = 1 ;
        end
    end
end

% Deleting bad Data:
timedots = 0 ;
telnum = 0 ;

if sum(badData) ~= 0
    whereBad = find(badData == 1) ; % gives us the j of the datas we need to find the missing points.
    
    DelMissing(whereBad, Data) ; % the first delete
    load Results % because the variables are not global, they don't get to the workspace.
    
    % FOR XML AND XLSX- FOR XLS WE SHOLUD DO SORTROWS
    for j = 1 : i-2
        for telN = 1 : Data(j).telnum
            tOriginal = Data(j).Positions(:, Data(j).timeCol) ;
            tWanted = (repmat( 1 : Data(j).timedots, 1, Data(j).telnum ))' ;
            if length(tOriginal) ~=  length(tWanted) % for checking if there is another bad telomere on the same file, so we can delete it.
                DelMissing(j, Data) ; % delete again
                load Results % again because of they're local
            else
                break % if there aren't any telomeres to delete, break out of the loop
            end
        end
        telnum = telnum + Data(j).telnum ; % the telomeres number after all the deletions.
        timedots = timedots + Data(j).timedots ;
    end
    
    
else
    clear 'badData'
    clear 'datRemove' 'rem'
end

% Correcting drift and rotation:
% Moshe does mean for every timedot, displays the mean of all the telomeres
% in the timedot, for x, y, z. I need to do the mean for all of them
% together (all the Data) and then delete from each one.

% finding the drift:
for j = 1 : i-2
    Data(j).findDrift = sortrows(Data(j).Positions, Data(j).timeCol) ;
    Data(j).tracks = zeros(Data(j).telnum, 3, Data(j).timedots) ; % 100 matrices of spots of telomeres at each timepoint
    
    for k = 1 : Data(j).timedots
        Data(j).tracks(:, :, k) = Data(j).findDrift( (k-1)*Data(j).telnum + 1 : k*Data(j).telnum, [Data(j).xCol, Data(j).yCol, Data(j).zCol] ) ;
    end
    
    Data(j).drift = mean(Data(j).tracks, 1) ; % this is the drift
    Data(j).drift = repmat(Data(j).drift, [Data(j).telnum, 1, 1] ) ; % so we can substract
    Data(j).tracks = Data(j).tracks - Data(j).drift ;
    Data(j).tracks = rotation(Data(j).tracks) ; % rotation correction
    
    for k = 1 : Data(j).timedots
        Data(j).findDrift( (k-1)*Data(j).telnum + 1 : k*Data(j).telnum, [Data(j).xCol, Data(j).yCol, Data(j).zCol] ) = Data(j).tracks(:, :, k) ;
    end
    
    % Now sort back to the 1 2 3... each tel with itself
    
    rep = 1 : Data(j).telnum ;
    rep = (repmat(rep, [1, Data(j).timedots]))' ;
    Data(j).Positions1 = [rep, Data(j).findDrift] ;
    Data(j).Positions1 = sortrows(Data(j).Positions1, 1) ;
    Data(j).Positions = Data(j).Positions1(:, 2:end) ;
    
    Data(j).timeCol = 1 ;
    Data(j).xCol = 2 ;
    Data(j).yCol = 3 ;
    Data(j).zCol = 4 ;   % In case we were not on XLSX and we had more nans coloumns.
end

for j = 1 : i-2
    if Data(j).timedots > wantedTD
%         ind2del = find(Data(j).Positions(:, Data(j).timeCol)>wantedTD);
        Data(j).Positions(...
            Data(j).Positions(:, Data(j).timeCol)>wantedTD...
            ,:)=[];
        Data(j).timedots=wantedTD;
    end
end

% Putting in a vector position matrix:
vecPosMat = cell(telnum, Data(j).timedots) ;  % each row - what the position of each telomere in every timepoint. assuming all have the same timedots
indention = 0 ;
for j = 1 : i-2
    for tel = 1 : Data(j).telnum    % the one was place before
        for t = 1 : Data(j).timedots
            vecPosMat(tel + indention, t) =...
                {[Data(j).Positions(t+(tel-1)*Data(j).timedots, Data(j).xCol),...
                Data(j).Positions(t+(tel-1)*Data(j).timedots, Data(j).yCol)]} ;
        end
    end
    indention = indention + Data(j).telnum ; % this new value for the sec data to run from the start but in the new one to run from the last place.
    %     vec1 = Data(j).vecPosMat(:, 1) ;
    % Initial positions
    %     Data(j).initialP = zeros(Data(j).telnum, 2) ;
    %     for h = 1 : Data(j).telnum
    %         Data(j).initialP(h, :) = vec1{h} ;
    %     end
end