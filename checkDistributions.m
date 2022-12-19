% L_X1 = all_L(1).X ;
% L_Y1 = all_L(1).Y ;
% L_R1 = all_L(1).R ;
% 
% L_X5 = all_L(5).X ;
% L_Y5 = all_L(5).Y ;
% L_R5 = all_L(5).R ;
% 
% L_X10 = all_L(10).X ;
% L_Y10 = all_L(10).Y ;
% L_R10 = all_L(10).R ;
% %%
% WL_X1 = all_WL(1).X ;
% WL_Y1 = all_WL(1).Y ;
% WL_R1 = all_WL(1).R ;
% 
% WL_X5 = all_WL(5).X ;
% WL_Y5 = all_WL(5).Y ;
% WL_R5 = all_WL(5).R ;
% 
% WL_X10 = all_WL(10).X ;
% WL_Y10 = all_WL(10).Y ;
% WL_R10 = all_WL(10).R ;

V=dtWWm5(cell).dt5;
h1=histogram(V,'Normalization','probability','Visible','off');
if h1.NumBins<30
h1.NumBins=30;
end
x=h1.BinEdges-h1.BinWidth/2;
x(1)=[];
y=h1.Values;
close all