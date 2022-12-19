function createRecPlot(Data)
% This function creates recurrence plot for the telomeres in the data.
valVec = [] ;
thresh = [] ;
for filesNum = 1 : length(Data)
    for dt = 2 : 2 : 6
        steps = Data(filesNum).WoOrder(dt).Rsquare ;
        steps = reshape(steps, numel(steps)/...
            Data(filesNum).telnum, Data(filesNum).telnum) ;
        Mats(dt).recMat = cell(Data(filesNum).telnum) ;
        
        for telN = 1 : Data(filesNum).telnum
            for telM = 1 : Data(filesNum).telnum
                if telM > telN
                    val = steps(:, telM) - steps(:, telN) ;
                    valVec = cat(1, valVec, val) ;
                    thresh(end+1) = std(valVec) ;
                end
            end
        end
        
        ind = 1 ;
        for telN = 1 : Data(filesNum).telnum
            for telM = 1 : Data(filesNum).telnum
                if telM > telN
                    val = steps(:, telM) - steps(:, telN) ;
                    val(val<-abs(thresh(ind)) | val>abs(thresh(ind))) = 0 ;
                    Mats(dt).recMat{telN, telM} = val ;
                    ind = ind+1 ;
                end
            end
        end
        
    end
end

% if smaller than thresh than 1 else 0 for every element in the matrix and
% then plot it, telN vs telM all dt together?
% I need to calculate the std of