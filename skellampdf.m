function [ y ] = skellampdf( x , lambda1 , lambda2 )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

y = exp(-lambda1 - lambda2) * (lambda1/lambda2).^(x/2) .* besseli(abs(x),2*sqrt(lambda1*lambda2));


end

