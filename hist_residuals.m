% function [fitresult, gof] = hist_residuals(alldis)

%????? ?????: 
% ????? ?? alldis
% ????? ?? ????? ????? ????
% ???? ?? ????? y ?????
%%
% Create figure
% alldis=dis;
% alldis=alldiss;
% alldis=diss;
figure1 = figure('Color',[1 1 1]);

% Create axes
axes1 = axes('Parent',figure1,...
    'Position',[0.13 0.393526405451448 0.775 0.531473594548553]);
hold(axes1,'on');
%%
% alldis=dis;
alldisclean=alldis;
B= [find(isnan(alldisclean))];
% alldiscleaer1234
% n(B)=[];

% sigma=mean(alldisclean)*sqrt(2/pi);
meandis=mean(alldisclean);

hisdis = histogram(alldisclean);
hisdis.Normalization= 'probability';
% meandis = mean(alldisclean,'omitnan');
% stddis = std(alldisclean,'omitnan');
hisdis.FaceColor=[0,0,0];
bin_width=hisdis.BinWidth;
%%
disV=hisdis.Values;

x=1:hisdis.NumBins;
for i=1:hisdis.NumBins
    
x(i)=(hisdis.BinEdges(i+1)+hisdis.BinEdges(i))/2;
end

%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( x, disV );

% Set up fittype and options.
ft = fittype( 'x/sigma^2)*exp((-x^2)/(2*sigma^2))*bin_width+(x/sigma2^2)*exp((-x^2)/(2*sigma2^2))*bin_width', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Lower = [bin_width -inf];
opts.StartPoint = [bin_width 0.2];
opts.Upper = [bin_width inf];

% Fit model to data.
[fitresult, gof, output] = fit( xData, yData, ft, opts );
%%
ydis=0:0.05:1.5;
p = raylpdf(ydis,fitresult.sigma);
% fdis = hisdis.BinWidth*(exp(-(ydis-sigma).^2./(2*stddis^2))./(sigma^2)));
plot(ydis,p*hisdis.BinWidth,'LineWidth',1.5,'linewidth',2.5,'color',[128/256 0 0]);

yyyyy=title('Distance between two rods');
rsqr=gof.rsquare;
textbox=sprintf('mean = %0.2fnm \n\\sigma = %0.2fnm \nn = %d \nR^2= %0.2f',meandis, fitresult.sigma, length(alldisclean), rsqr);
textbox=sprintf('\\sigma = %0.2fnm \nn = %d \nR^2= %0.2f',fitresult.sigma, length(alldisclean), rsqr);
%text(50,0.13,{['mean = ' num2str(meandis) 'nm'], ['\sigma = ' num2str(sigma) 'nm'], ['n=' num2str(length(alldisclean))]});
yyyy=text(0.75*max(ydis),0.9*max(p*hisdis.BinWidth),{textbox});
% annotation('textbox',[0.5,0.5,0.5,0.5],'String',textbox,'FitBoxToText','on');
% xlabel('Distance [nm]');
yy=ylabel('Frequency');
yy.Position(1)=-5.5;


%%
% Create axes
axes2 = axes('Parent',figure1,...
    'Position',[0.13 0.11 0.775 0.205161839863714]);
hold(axes2,'on');

%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( x, disV );

% Set up fittype and options.
ft = fittype( '(x/sigma^2)*exp((-x^2)/(2*sigma^2))*bin_width+(x/sigma2^2)*exp((-x^2)/(2*sigma2^2))*bin_width', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Lower = [bin_width -inf];
opts.StartPoint = [0.0357116785741896 300];
opts.Upper = [bin_width inf];

% Fit model to data.
[fitresult, gof, output] = fit( xData, yData, ft, opts );

% Create a figure for the plots.
% figure( 'Name', 'untitled fit 1' );

% % Plot fit with data.
% subplot( 2, 1, 1 );
% h = plot( fitresult, xData, yData );
% legend( h, 'disV vs. x', 'untitled fit 1', 'Location', 'NorthEast' );
% % Label axes
% xlabel x
% ylabel disV
% grid on

% Plot residuals.
% subplot( 2, 1, 2 );
% %%
stem( xData,output.residuals,'DisplayName','fit - residuals','Parent',axes2,...
    'MarkerFaceColor',[0 0 0],...
    'MarkerEdgeColor',[0 0 0],...
    'MarkerSize',3,...
    'Color',[0 0 0]);
yyyyyy=xlabel('Distance [nm]');
yyyyyy.Position(2)=-0.075;

yyy=ylabel('Residuals');
yyy.Position(1)=-5.5;

axes1.FontSize=12;
axes2.FontSize=12;
yy.FontSize=14;
yyy.FontSize=14;
yyyy.FontSize=14;
yyyyy.FontSize=14;
yyyyyy.FontSize=14;

%%

% h=plot( fitresult, xData, yData, 'residuals' );
% legend( h, 'untitled fit 1 - residuals', 'Zero Line', 'Location', 'NorthEast' );
% % Label axes
% xlabel x
% ylabel disV
% grid on


