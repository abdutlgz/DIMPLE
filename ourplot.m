subplot(1,3,1);
x = LL;
plot(x,nwMEANb(:,1),'r-o',x,nwMEANb(:,2),'g-o',x,nwMEANb(:,3),'k-o',x,nwMEANb(:,4),'b-o')
legend('w=0.6', 'w=0.8', 'w=1.0', 'w=1.2')
title('(1)Between-layer (Alg.1)')
xlabel('L')
ylabel('Clustering Error')

subplot(1,3,2); 
plot(x,nwMEANw2(:,1),'r-o',x,nwMEANw2(:,2),'g-o',x,nwMEANw2(:,3),'k-o',x,nwMEANw2(:,4),'b-o')
legend('w=0.6', 'w=0.8', 'w=1.0', 'w=1.2')
title('(2)Within-layer (Alg.2)')
xlabel('L')
ylabel('Clustering Error')

subplot(1,3,3); 
plot(x,nwMEANw3(:,1),'r-o',x,nwMEANw3(:,2),'g-o',x,nwMEANw3(:,3),'k-o',x,nwMEANw3(:,4),'b-o')
legend('w=0.6', 'w=0.8', 'w=1.0', 'w=1.2')
title('(3)Within-layer (Alg.3)')
xlabel('L')
ylabel('Clustering Error')