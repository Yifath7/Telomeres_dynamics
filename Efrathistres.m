figure1 = figure('Color',[1 1 1]);

% Create axes
axes1 = axes('Parent',figure1,...
    'Position',[0.13 0.393526405451448 0.775 0.531473594548553]);
hold(axes1,'on');
 
% sigma=mean(alldisclean)*sqrt(2/pi);
meandis=mean(V);

h1 = histogram(V, ceil(sqrt(length(V))));
h1.Normalization= 'probability';
% meandis = mean(alldisclean,'omitnan');
% stddis = std(alldisclean,'omitnan');
h1.FaceColor=[0,0,0];
w1=h1.BinWidth;
x=h1.BinEdges-h1.BinWidth/2;
x(1)=[];
y=h1.Values;

%% Fit: '2-Rayleigh sum'.
[xData, yData] = prepareCurveData( x, y );

% Set up fittype and options.
% Set up fittype and options.
ft = fittype( '((1/sqrt(2*pi*s^2))*exp(-((x-m).^2./(2*s^2)))*w1)+w2*((1/(2*b))*exp(-abs(x-m)/b))', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Lower = [-Inf -Inf -Inf 0 -Inf];
opts.StartPoint = [0.412266685717863 0.16372510775086 0.412668434504101 0.0167358535458427 0.0304804496881115];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );
s=fitresult.s;
w1=fitresult.w1;
m=fitresult.m;
b=fitresult.b;
w2=fitresult.w2;
plot(x,((1/sqrt(2*pi*s^2))*exp(-((x-m).^2./(2*s^2)))*w1)+w2*((1/(2*b))*exp(-abs(x-m)/b)),'LineWidth',1.5,'linewidth',2.5,'color',[128/256 0 0])

t1 = title('Gaussian + Laplace fit, Lmna^{-/-} step size of telomeres in \Deltat=10') ;
% rsqr=gof.rsqure;

% textbox=sprintf('\\sigma = %0.2f\mum \nn = %d \nR^2= %0.2',fitresult.sigma, length(V));
% txt=text(0.75*max(V),0.9*max(p*hisdis.BinWidth),{textbox});
yl = ylabel('Frequency') ;
% yl.Position(1)=-2.5;

% Create axes
axes2 = axes('Parent',figure1,...
    'Position',[0.13 0.11 0.775 0.205161839863714]);
hold(axes2,'on');

[xData, yData] = prepareCurveData( x, y );

% Set up fittype and options.
ft = fittype( '((1/sqrt(2*pi*s^2))*exp(-((x-m).^2./(2*s^2)))*w1)+w2*((1/(2*b))*exp(-abs(x-m)/b))', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Lower = [-Inf -Inf -Inf 0 -Inf];
opts.StartPoint = [0.412266685717863 0.16372510775086 0.412668434504101 0.0167358535458427 0.0304804496881115];
% Fit model to data.
[fitresult, gof, output] = fit( xData, yData, ft, opts );
stem( xData,output.residuals,'DisplayName','fit - residuals','Parent',axes2,...
    'MarkerFaceColor',[0 0 0],...
    'MarkerEdgeColor',[0 0 0],...
    'MarkerSize',3,...
    'Color',[0 0 0]);
xl2 = xlabel('Step size [\mum]') ;
% xl2.Position(2) = -0.075;
yl2 =ylabel('Residuals');
% yl2.Position(1) = -5.5 ;
axes1.FontSize=12;
axes2.FontSize=12;
yl.FontSize=14;
xl2.FontSize=14;
yl2.FontSize=14;
% txt.FontSize=14;
t1.FontSize=14;

%% Fit: 'solo Gaussian'.
[xData, yData] = prepareCurveData( x, y );

% Set up fittype and options.
% Set up fittype and options.
ft = fittype( '(1/sqrt(2*pi*s^2))*exp(-(x-m).^2/(2*s^2))*bin_width', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Lower = [-Inf -Inf -Inf];
opts.StartPoint = [0.412668434504101 0.0167358535458427 0.0304804496881115];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );
s=0.2256;
% w1=fitresult.w1;
m=0.00459;
b=0.02797;
% w2=fitresult.w2;
plot(x,(1/sqrt(2*pi*s^2))*exp(-(x-m).^2/(2*s^2))*bin_width,'LineWidth',1.5,'linewidth',2.5,'color',[128/256 0 0]);
t1 = title('Gaussian fit, Lmna^{-/-} step size of telomeres in \Deltat=10') ;
% rsqr=gof.rsqure;

% textbox=sprintf('\\sigma = %0.2f\mum \nn = %d \nR^2= %0.2',fitresult.sigma, length(V));
% txt=text(0.75*max(V),0.9*max(p*hisdis.BinWidth),{textbox});
yl = ylabel('Frequency') ;
% yl.Position(1)=-2.5;

% Create axes
axes2 = axes('Parent',figure1,...
    'Position',[0.13 0.11 0.775 0.205161839863714]);
hold(axes2,'on');

[xData, yData] = prepareCurveData( x, y );

% Set up fittype and options.
ft = fittype( '(1/sqrt(2*pi*s^2))*exp(-(x-m).^2/(2*s^2))*bin_width', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Lower = [-Inf -Inf -Inf];
opts.StartPoint = [ 0.412668434504101 0.0167358535458427 0.0304804496881115];
% Fit model to data.
[fitresult, gof, output] = fit( xData, yData, ft, opts );
stem( xData,output.residuals,'DisplayName','fit - residuals','Parent',axes2,...
    'MarkerFaceColor',[0 0 0],...
    'MarkerEdgeColor',[0 0 0],...
    'MarkerSize',3,...
    'Color',[0 0 0]);
xl2 = xlabel('Step size [\mum]') ;
% xl2.Position(2) = -0.075;
yl2 =ylabel('Residuals');
% yl2.Position(1) = -5.5 ;
axes1.FontSize=12;
axes2.FontSize=12;
yl.FontSize=14;
xl2.FontSize=14;
yl2.FontSize=14;
% txt.FontSize=14;
t1.FontSize=14;
