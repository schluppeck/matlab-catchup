function  [m, sd, n, myMax ] = myStats( inputNumbers )
% myStats - returns mean, std, numel() and max
%
% this function takes an input a list of numbers
% and returns 4 values as in the description
%
% ds 2022-11-21, for matlab class

m = mean( inputNumbers, 1 );
sd = std( inputNumbers, 1 );
n = numel( inputNumbers );
myMax = max( inputNumbers, [], 1 );

% s = [m, sd, n, myMax ];
end