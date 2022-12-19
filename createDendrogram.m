function [axes1] = createDendrogram(vecPosMat, Data)
% This function creates the dendrogram plot for a given cell file.

%%% Initial Positions %%%
vec1 = vecPosMat(:, 1) ;
initialP = zeros(length(vec1), 2) ;
for i = 1 : length(vec1)
    initialP(i, :) = vec1{i} ;
end

%%% Dendrogram without excell %%%
leafO = [] ;
tree = linkage(initialP) ;
telnumTot = size(vecPosMat, 1) ;
for ii = 1 : length(tree)
    for jj = 1 : 2
        if tree(ii,jj) <= telnumTot
            leafO(end+1) = tree(ii,jj) ;
        end
    end
end
D = pdist(initialP);
%leafOrder = optimalleaforder(tree,D) ;
% leafOrder = axes3 ;
figure() ;
[dend, T] =dendrogram(tree,  'Orientation', 'Left', 'ColorThreshold',0.5*max(tree(:,3)));
% p1 = get(s1, 'pos') ;
% p1(3) = p1(3) + 0.01; % width
% p1(2) = p1(2) + 0.01 ; % move in y
% p1(4) = p1(4) - 0.01; % height
% p1(1) = p1(1) - 0.02; % move in x
% p1(1) = 0.09 ;
% p1(2) = 0.06 ;
% p1(3) = 0.3613 ;
% p1(4) =0.855 ;
set(gca,'FontSize',14)
% set(s1,'pos', p1)
axes1 = str2num(get(gca, 'YTickLabel')) ;
title([Data.Name(1:end-9), ' Dendrogram'])

%%% Save figure %%%
cd('.\Output Figures\Dendrograms') ;
% cd('D:\Dropbox\GariniLab\Diffusion files\Trying to put in functions\Output Figures\Dendrograms') ;
saveas(gcf, [Data.Name(1:end-9), ' Dendrogram.tif']) ;
cd('..\..\') ;
% cd('D:\Dropbox\GariniLab\Diffusion files\Trying to put in functions') ;
% p1 = 0.13 0.1 0.3613 0.855