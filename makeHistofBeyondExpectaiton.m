function makeHistofBeyondExpectaiton(dt_series, Data, DataWL)
% This function takes all data and makes histogram of the amount of
% telomeres that made extra-long directional steps in a certain dt.

%% Number of telomeres that exceeded the expected value.
% we need first to make a matrix that collects all the R variables for each
% telomere in a certain dt.

%%
%{
COMPUTE SIGMA FOR ALL LMNA AND FOR ALL WOLMNA. ASK YUVAL IF THAT MAKES
SENSE. I THINK IT'S SUPPOSED TO BE ONE FOR EVERYONE, NO ACTUALLY. MAYBE
NOT. MAYBE FOR LMNA NAD FOR WOLMNA THE TYPICAL SIZE MATTERS AND VARIES.
WRITE THIS IN MY AMAZIMG THESIS PLEASE.
%}
%%
% initials:
R_above_num_L = zeros(1, length(dt_series)) ;
R_above_num_WL = zeros(1, length(dt_series)) ;
% tel_L = sum([Data.telnum]) ;
% tel_WL = sum([DataWL.telnum]) ;
timedots = 50 ; % because it contains all data.
load sigmaA_WL

% lmna+/+ data:
for jj = 1 : length(Data)
    
    %     timedots = Data(jj).timedots ;
    tel_L = Data(jj).telnum ;
    for dt = dt_series
        dtN = timedots - dt ;
        RL = zeros(tel_L, dtN) ;
        %         for DT = 1 : 2
        %             Dc(DT) = mean(Data(jj).WoOrder(DT).Rsquare)./(4*DT) ;
        %         end
        %         Dcoef = mean(Dc);
        
        
        sigma = 1.5*sigmaWL(dt) ;
        for telN =  1 : tel_L
            RL(telN, :)= sqrt(Data(jj).WoOrder(dt).Rsquare((telN-1)*dtN+1 : telN*dtN))- sigma;
        end
        tel_above = sum(RL>0, 2) ;
        R_above_num_L(dt_series == dt) = R_above_num_L(dt_series == dt) + sum(tel_above>0) ;
    end
end

R_above_num_L = R_above_num_L / sum([Data.telnum]) ;


% lmna-/- data:
for jj = 1 : length(DataWL)
    %     timedots = DataWL(jj).timedots ;
    tel_WL = DataWL(jj).telnum ;
    for dt = dt_series
        sigma = 1.5*sigmaWL(dt) ;
        dtN = timedots - dt ;
        RWL = zeros(tel_WL, dtN) ;
        
        for telN =  1 : tel_WL
            RWL(telN, :)= sqrt(DataWL(jj).WoOrder(dt).Rsquare((telN-1)*dtN+1 : telN*dtN))- sigma;
        end
        tel_above = sum(RWL>0, 2) ;
        R_above_num_WL(dt_series == dt) = R_above_num_WL(dt_series == dt) + sum(tel_above>0) ;
    end
end

R_above_num_WL = R_above_num_WL / sum([DataWL.telnum]) ;


% bar plot
figure;
bar([R_above_num_L', R_above_num_WL']) ;
set(gca, 'FontSize', 14) ;
set(gca, 'XTickLabel', num2cell(dt_series)) ;
title('Amount of exceeding telomeres for different \Deltat') ;
legend({'lmna^{+/+}', 'lmna^{-/-}'}) ;
cur_dir = pwd ;
% cd('D:\Dropbox\GariniLab\Diffusion files\Trying to put in functions\Output Figures\Exceeding Telomeres') ;
% saveas(gcf, ['bar_plot',num2str(dt),'.tif']);
% cd(cur_dir) ;


% histograms - how far from expectation?

% lmna+/+ data:
all_RL = [];
% then to use cat.
for jj = 1 : length(Data)
    timedots = Data(jj).timedots ;
    tel_L = Data(jj).telnum ;
    for dt = dt_series
        sigma = 1.5*sigmaWL(dt) ;
        dtN = timedots - dt ;
        RL = zeros(tel_L, dtN) ;
%         for DT = 1 : 2
%             Dc(DT) = mean(Data(jj).WoOrder(DT).Rsquare)./(4*DT) ;
%         end
%         Dcoef = mean(Dc);
%         sigma = 2*sqrt(Dcoef*dt) ;
        for telN =  1 : tel_L
            RL(telN, :)= sqrt(Data(jj).WoOrder(dt).Rsquare((telN-1)*dtN+1 : telN*dtN))- sigma;
        end
        RL(RL<0) = 0 ;
        temp = cat(2, all_RL, reshape(RL,1,numel(RL))) ;
        all_RL = temp ;
    end
end


% lmna-/- data:
all_RWL = [];
for jj = 1 : length(DataWL)
    timedots = DataWL(jj).timedots ;
    tel_WL = DataWL(jj).telnum ;
    for dt = dt_series
        sigma = 1.5*sigmaWL(dt) ;
        dtN = timedots - dt ;
        RWL = zeros(tel_WL, dtN) ;
%         for DT = 1 : 2
%             Dc(DT) = mean(DataWL(jj).WoOrder(DT).Rsquare)./(4*DT) ;
%         end
%         Dcoef = mean(Dc);
%         sigma = 2*sqrt(Dcoef*dt) ;
        for telN =  1 : tel_WL
            RWL(telN, :)= sqrt(DataWL(jj).WoOrder(dt).Rsquare((telN-1)*dtN+1 : telN*dtN))- sigma;
        end
        RWL(RWL<0) = 0 ;
        temp = cat(2, all_RWL, reshape(RWL,1,numel(RWL))) ;
        all_RWL = temp ;
    end
end

figure ;
hL = histogram(all_RL) ;
hL.Normalization = 'Probability' ;
hold on
hWL = histogram(all_RWL) ;
hWL.Normalization = 'Probability' ;

figure ;
plot(all_RWL./203 - all_RL./957);

