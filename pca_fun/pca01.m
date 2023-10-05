load fisheriris;
X = meas;
[coeff,score,latent,tsquare]=pca(X);
Y = X*coeff(:,1:2);
gscatter(Y(:,1),Y(:,2),species);
xlabel('P 1');
ylabel('P 2');