w1=(norm(X1))/(norm(X1)+norm(X2)+norm(X3));
w2=(norm(X2))/(norm(X1)+norm(X2)+norm(X3));
w3=(norm(X3))/(norm(X1)+norm(X2)+norm(X3));
Positions(i,j)=(w1*X1+w2*X2+w3*X3)/3;
w1=(lambda1)/(lambda1+lambda2+lambda3);
w2=(lambda2)/(lambda1+lambda2+lambda3);
w3=(lambda3)/(lambda1+lambda2+lambda3);
Positions(i,j)=(w1*X1+w2*X2+w3*X3)/3;