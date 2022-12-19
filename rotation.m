function C=rotation(B)
timeptsn = length(B(1,1,:));
tracksn = length(B(:,1,1));

%Caculating the teta in polar coordinates (angle from x axis)in itervals of
%0-2pi (where 2pi is zero).
teta=zeros(tracksn,timeptsn-1);
ro=zeros(tracksn,timeptsn-1);
rotangle=zeros(1,timeptsn);
C=B;

for i=2:timeptsn
    for j=1:tracksn
        x1=C(j,1,1);y1=C(j,2,1);
        x2=C(j,1,i);y2=C(j,2,i);
        [teta1,ro1]=cart2pol(x1,y1);
        [teta2,ro2]=cart2pol(x2,y2);
        teta(j,i)=teta2-teta1;
        ro(j,i)=mean([ro1,ro2], 'omitnan');
        if abs(teta(j,i))>pi
            %teta should be -pi to pi (for the mean to be exact).
            teta(j,i)=(-2*pi*fix(teta(j,i)/pi)+teta(j,i));
        end
        if ro(j,i)<4
            teta(j,i)=NaN;
        end
            
    end
    rotangle(i)=mean(teta(:,i), 'omitnan'); 
%     rotangle(i)=rotangle(i-1)+nansum(teta(:,i).*ro(:,i))/nansum(ro(:,i));
    r=[cos(rotangle(i)),sin(rotangle(i));-sin(rotangle(i)),cos(rotangle(i))];

    for j=1:tracksn
        C(j,1:2,i)=r*squeeze(C(j,1:2,i))';
    end
end
clear teta ro rotangle i j x1 x2 r