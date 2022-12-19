%% Deleting Telomeres with Missing Time Dots:  DELETED THE IS XLSX NOT CHECKED YET

function DelMissing(whereBad, Data)
for b = 1 : length(whereBad) % runs over all the serial num of the bad data
    tOriginal = Data( whereBad(b)).Positions(:, Data(whereBad(b)).timeCol) ; % our timepoints
    tWanted = repmat(1:Data(whereBad(b)).timedots, 1, Data(whereBad(b)).telnum) ; % we wanted it to be that way.
    dl = abs(length(tWanted) - length(tOriginal)) ;
    if length(tWanted) - length(tOriginal) >= 0
        tWanted = (tWanted(1 : end-dl))' ;
    else
        tWanted = [tWanted , 1:dl]' ;
    end
    indVec = find(tOriginal ~= tWanted) ; % Indices of where it's wrong. we need the first.
    if isempty(indVec) == 1 % means that it ends with less then 50 points.
        enValue = Data(whereBad(b)).Positions(end, Data(whereBad(b)).timeCol) ;
        Data(whereBad(b)).Positions(end-enValue+1 :end,:) = [] ;
        Data(whereBad(b)).telnum = Data(whereBad(b)).telnum-1 ;
    else
        fi = indVec(1) ; % the first index where not equal. tWanted(fi) is what missing in tOriginal
        clear 'indVec'
        wOnes = find( tOriginal == 1 ) ;
        wEnds = find( tOriginal == Data(whereBad(b)).timedots ) ;
        wAll = [wOnes', wEnds'] ; % tag for transpose, dimensions
        wAll = sort(wAll) ; % index of 1, index of 50 index of 1 etc.
        % if tOriginal(fi) ~=1 or 50
        if tOriginal(fi) ~= 1 && tOriginal(fi) ~= Data(whereBad(b)).timedots
            wAll(end+1) = fi ; % adding the first bad index
            wAll = sort(wAll) ;
            whereDel = find( wAll == fi ) ;
            FirstD = wAll(whereDel - 1) ; % index of 1
            LastD = wAll(whereDel + 1) ; % index of last timedot
            Data(whereBad(b)).Positions(FirstD : LastD, :) = [] ; % NEED TO CHECK AGAIN LATER
            
        elseif tOriginal(fi) == 1
            % in this case, we already have fi in wAll. so
            % NOTEBOOK P53 %
            % we'll just find the one, and delete from the one
            % before (fi-2) to the 50 before (fi-1)
            whereDel = find( wAll == fi ) ;
            if whereDel > 2   % I'M HEREEEEEEEEEE
                if isempty( find( wAll(whereDel - 2) == wOnes, 1 ) ) == 1 % meaning whereDel-2 is of 50
                    FirstD = wAll(whereDel - 1) ; % and this will be the one.
                    LastD = fi - 1 ; % in cases we have no 50.
                else
                    FirstD = wAll(whereDel - 2) ; % 1
                    LastD = wAll(whereDel - 1) ; % 50
                end
            else % in these cases, we have 12 1234... so we need to delete the 12 or the 1.
                FirstD = wAll(1) ;
                LastD = wAll(whereDel)-1 ;
            end
            
            Data(whereBad(b)).Positions(FirstD : LastD, :) = [] ;
            
        elseif tOriginal(fi) == Data(whereBad(b)).timedots
            % again, we have fi in wAll
            % we need to delete from the one before fi to fi.
            whereDel = find( wAll == fi ) ;
            FirstD = wAll(whereDel - 1) ;
            LastD = wAll(whereDel) ;
            Data(whereBad(b).Position(FirstD : LastD, :)) = [] ;
        end
        
        Data(whereBad(b)).telnum = Data(whereBad(b)).telnum-1 ;
        %         telnum = telnum-1 ;
        
        % now we should check from FirstD forward.
        
    end % if
end % for
save Results
end