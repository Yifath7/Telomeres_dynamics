function dtWW=dtWoOrder(dt)
prompt = 'Enter #timedots' ;
title = 'Input' ;
num_lines = 1 ;
def = {'50'} ;
timedots = inputdlg(prompt, title, num_lines, def);
timedots = str2double(timedots) ;
[Data, vecPosMat, button] = initialLoad(timedots) ;
vecPosMat_init = vecPosMat ;

for filesNum = 1 : length(Data)
    [WoOrder, vecPosMat] = createNoOrder(timedots, vecPosMat_init, Data, filesNum) ;
    dtWW(filesNum).dt1=WoOrder(dt).X;
end