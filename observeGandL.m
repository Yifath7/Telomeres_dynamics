fL=@(w2,b,x) w2*((1/(2*b))*exp(-abs(x-m)/b)) ;
fG=@(w1,s,x,m) ((1/sqrt(2*pi*s^2))*exp(-((x-m).^2./(2*s^2)))*w1) ;
b=0.04752;
m=-0.004197;
s=0.06284;
w1=0.01224;
w2=0.007698;
x=-.2:.001:.2;

figure;
plot(x,fL(w2,b,x))
hold on
plot(x,fG(w1,s,x,m));
