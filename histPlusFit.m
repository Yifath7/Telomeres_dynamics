close all
V=all_WL(10).X;

h1=histogram(V,'Normalization','probability','Visible','off');
%ceil(sqrt(len5gth(V))),
x=h1.BinEdges-h1.BinWidth/2;
x(1)=[];
y=h1.Values;

[fitresult, gof] = createFit(x, y)
bin_width=fitresult.bin_width;
m=fitresult.m;
s=fitresult.s;
h1=histogram(V,'Normalization','probability');
hold on
% plot(x,((x./s^2).*exp(-x.^2./(2*s^2)))*bin_width,'linewidth',2)
plot(x,(1/sqrt(2*pi*s^2))*exp(-(x-m).^2/(2*s^2))*bin_width,'linewidth',2)

set(gca,'FontSize',14);
xlabel('Sizes of steps [\mum]')
title('Distribution of steps sizes, \Deltat=')
% cftool
% 
% todel = find(x<-0.4|x>0.4);
% x(todel)=[];
% y(todel)=[];