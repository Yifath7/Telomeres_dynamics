%%% Fit for everyone:
w1=zeros(10,1);
w2=zeros(10,1);
m=zeros(10,1);
b=zeros(10,1);
s=zeros(10,1);
for cell = [1 : 29]
    V=dtWWp5(cell).dt5;
    h1=histogram(V,'Normalization','probability','Visible','off');
    if h1.NumBins<30
        h1.NumBins=30;
    end
    x=h1.BinEdges-h1.BinWidth/2;
    x(1)=[];
    y=h1.Values;
    [fitresult, gof] = createFit1(x, y) ;
    w1(cell)=fitresult.w1;
    w2(cell)=fitresult.w2;
    m(cell)=fitresult.m;
    b(cell)=fitresult.b;
    s(cell)=fitresult.s;
    
end