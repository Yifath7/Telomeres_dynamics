function createHeatMap(WoOrder)
%% Finally putting in the table we want:
% Now each column will be dt (from 1 to 49 I guess) and each row will be
% the typical size of r^2. At first we'll try with 100 divisions.
numOfDiv  = inputdlg('Enter number of divisions:', 'Input', 1, {'100'}) ;
numOfDiv = str2double(numOfDiv) ;
% find Rmax in WithoutOrder, and then to make the typical R vec, P47 in my
% notebook. I guess we should do it with linspace, 0, Rmax and the
% divisions number is numOfDev.
% After that, we should run over WoO(dt).Rsquare(1:end) and 'ask' each
% Rsquare where it is. HOW? abs(Rsquare\dr^2)
% dr^2 is our jumps in our devisions. WE NEED TO ROUND UP! P49
timedots = 50 ;
% We need to delete 5% of our data. (or other percent we choose) for that
% we calculate the num of our whole data and then find how much we need to
% cut off.
CutOffP = inputdlg('How many percent of the data do you want to cut off?', 'Input', 1, {'5'}) ;
CutOffP = str2double(CutOffP)/100 ; % now we just multiply
cutoffData = [] ;

%WoOrder -> vector
for dt = 1 : timedots-1
    cutoffData(end+1 : end + length(WoOrder(dt).Rsquare)) = WoOrder(dt).Rsquare ;
end

if CutOffP ~= 0 % When we want to delete
    cutoffData = sort(cutoffData) ; % sorting so we can find our new Rmax
    delNum = ceil( CutOffP*length(cutoffData) ) ; % number of how much data I should delete.
    cutoffData = cutoffData(1 : end-delNum+1) ;
    Rmax = max(cutoffData) ; % adjusting our new Rmax
    
else
    v = zeros(1, timedots-1) ;
    for dt = 1 : timedots-1
        v(dt) = max(WoOrder(dt).Rsquare) ;
    end
    Rmax = max(v) ;
end

% later we calculate msd and put it on our figure. if we want the msd to
% match our heat map, we need to delete from WoOrder.Rsquare the data we
% deleted in the cutOff data. so we define a new integer, Wo2, which is
% actually WoOrder just without what we cut. again, JUST FOR PLOTTING THE
% MSD.

for dt = 1 : timedots-1              % finding where there are data we should not consider while calculating the MSD.
    Wo2(dt).Rs = WoOrder(dt).Rsquare ;
    ind2del = [] ; % indices to delete later, for each dt.
    for h = 1 : length(Wo2(dt).Rs)
        findVec = any(Wo2(dt).Rs(h) == cutoffData) ; % supposed to have a number, not a vec.
        if findVec == 0
            ind2del(end+1) = h ;
        end % if
    end  % for
    Wo2(dt).Rs(ind2del) = [] ; % removes the values in the ind2del indices.
end % for

typicalR = linspace(0, Rmax, numOfDiv+1) ; % plus 1 because we do typicalR(i)-typicalR(i-1)
% linspace gives us a vec between xmin to xmax with n jumps
% [ linspace(xmin, xmax, n) ]
drs = typicalR(2) ; % it's after the zero.
% Prellocating our Heat Map Matrix:
HeatMM = zeros(numOfDiv, timedots-1) ; % columns- dt rows- typical

% Adding counts where there are events:
for dt = 1 : timedots-1
    for place = 1 : length( WoOrder(dt).Rsquare );
        if WoOrder(dt).Rsquare(place) < Rmax
            CubeSerNum = ceil(abs( WoOrder(dt).Rsquare(place)/drs)) ;
            HeatMM(CubeSerNum, dt) = HeatMM(CubeSerNum, dt) + 1 ; % We actually count the events at each typical R.
        elseif WoOrder(dt).Rsquare(place) == Rmax
            CubSerNum = numOfDiv ;
            HeatMM(CubeSerNum, dt) = HeatMM(CubeSerNum, dt) + 1 ; % We actually count the events at each typical R.
        end
    end
end

%clearvars -except HeatMM

% Now we need to normalize:
forNorm = sum(HeatMM, 1) ;
NormHeatMM = zeros(length(HeatMM(:, 1)), length(HeatMM(1, :))) ;

for ii = 1 : length(HeatMM(:, 1)) % rows
    for jj = 1 : length(HeatMM(1, :)) % columns
        NormHeatMM(ii, jj) = HeatMM(ii, jj)/forNorm(jj) ;
    end
end

%% Analyzing:
% If we want to see MSD without distribution:
hOfTime = ceil(timedots/2) ; % half of the timedots. We now that from some point in time we don't have enough data and our accuracy decreases.
msd = zeros(1, timedots-1) ;

for dt = 1 : timedots-1
    msd(dt) = mean(Wo2(dt).Rs) ; % doing the mean for the new cut off data.
end

NHMM = NormHeatMM*1000 ; % just to get to nicer values.
NHW0 = NHMM ;
NHW0( find(NHW0 == 0) ) = [] ; % oue values without zero so we can find the real mean
meanW0 = mean(NHW0(:)) ;
s = size(NHMM) ;
NHMM1 = reshape(NHMM, [1, s(1)*s(2)]);
stdHM = std(NHMM1);
h=pcolor((NHMM(:, 1:hOfTime))); % displaying for just half of the timedots.

% displaying meaningful data:
if  meanW0 <= stdHM
    set(gca, 'CLim', [0, meanW0+stdHM])
else
    set(gca, 'CLim', [meanW0-stdHM,meanW0+stdHM])
end

shading flat ;
colorbar ;
set(gca,'FontSize',16)
xlabel('\Deltat','FontSize',16) ;
ylabel( 'R^2') ;

RVectY = linspace(typicalR(2), Rmax, 5)' ; % the vector that represents the roof of each division.
RVectY = round(RVectY.*10^3)./10^3 ;
Rstr=num2str(RVectY)  ; % converting to string
set(gca,'YTickLabel',Rstr) % displaying instead of the 0-100 in Y axis.

str = {'LMNA', 'Without LMNA'} ;
[S, ok] = listdlg('Name','Fot plot title:','PromptString', 'Select LMNA or without LMNA:', 'SelectionMode', 'single','ListSize', [200, 100], 'ListString', str) ;

if S == 1 ;
    title('With LMNA, distribution of R^2') ;
else
    title('Without LMNA, distribution of R^2') ;
end