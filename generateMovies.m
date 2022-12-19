function generateMovies
% This function generates movies for all loaded cells and saves them in a
% specific folder. just a mix of all function so I don't have to do it cell
% by cell.

[Data, vecPosMat, button] = initialLoad ;
timedots = 50 ;
for filesNum = 1 : length(Data)
 createTracksMovie(Data(filesNum), Data(filesNum).telnum, timedots) ;
end