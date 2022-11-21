% script for looking at adding rows to existing 
% matrices (maybe also tables)


%% let's make an example matrix

M = magic(5);


% will make another on of the same width
% and pretend that it's a source of data that's coming 
% in one row at a time

%%
nColumns = size(M, 2);   % this is how many columns we need (based on what M was)
nRows = 15;
R = rand( [ nRows, nColumns] )


%% stick together in one go (not what we want)
% but maybe useful in some circumstances

combinedData = [M; R];

%% take one row from 2nd array and add (in a loop)

for iRow = 1:nRows
    
    % iRow
    
    currentRow = R(iRow,:);
    currentMean = mean(currentRow)
    M = [M; currentRow]
    pause
    
end


