function createPoincareMap(Data, WoOrder)
%% Poincare maps:
Positions = [] ;
for i = 1 : length(Data)
    Positions = [Positions ; Data(i).Positions] ;
end
x = Positions(:,2);
y = Positions(:,3);
count = 0 ;
count2 = 0 ;
while count < length(x)
    subplot(2,1,1)
    dscatter(x(1+count : 99+count),x( 2+count :100+count))
    hold on
    dscatter(y(1+count : 99+count),y( 2+count :100+count))
    count = count + 100 ;
    title('X and Y coardinates')
    xlabel('X_i', 'FontSize', 16)
    ylabel('X_{i+1}', 'FontSize', 16)
    set(gca,'FontSize',16)
    
    subplot(2,1,2)
    Rx = WoOrder(1).Rsquare;
    scatter(Rx(1+count2:98+count2),Rx(2+count2:99+count2))
    hold on
    count2 = count2 + 99 ;
    title('Distance R')
    xlabel('R_i')
    ylabel('R_{i+1}')
    set(gca,'FontSize',16)
end
suptitle('Poincare Plots, LMNA:')