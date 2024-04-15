function y = polyapdf(x,lambda,theta)
%   Y = polyapdf(x,lambda,theta) returns the Polya-Aeppli probability density 
%   function with parameters lambda and theta at the values in X.
%   Note that the density function is zero unless X is an integer.
%
%   The size of Y is the common size of the input arguments. A scalar input  
%   functions as a constant matrix of the same size as the other inputs


if nargin < 3
    error(message('stats:nbinpdf:TooFewInputs'));
end

if x(1)~=0
    error(message('the first element of x should be 0'));
end

%calculate each value y(k) by the recursive formula
L=length(x);
y=zeros(1,L);
z=lambda*theta/(1-theta);
y(1)=exp(-lambda);
y(2)=y(1)*(1-theta)*z;

if L>2
   for n=2:L-1
       y(n+1)=((2*n-2+z)/n)*(1-theta)*y(n)+((2-n)/n)*((1-theta)^2)*y(n-1);
   end
end


