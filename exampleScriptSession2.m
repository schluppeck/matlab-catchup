%% Some bits of exercises from the slides
a(1,1) = 0;
a(1,2) = 1;
nIterations = 6;
for i = 1:nIterations;
    a(1,i+2) = a(1,i) + a(1,i+1)
end
%%
 % make a random number between 0, 1
 a = rand(1)

 % now test if this time it is > or < than 0.5
 if a > 0.5
   disp('chance favours the prepared mind')
 else
  disp('uhoh!')
 end
%% ------
%% Problem-solving in Matlab
%% ------
%% requires 'RawData.csv' in current directory
current_directory = pwd; %find current working directory
datafile = [current_directory '/RawData.csv']; %assume the data file RawData.csv is in current directory

%our goal is to calculate mean RTs for a couple of conditions
%this can be broken down into a series of steps:
%1. Load the data into matlab
%2. understand whats in the data and how they are organized
%3. find the RT data
%4. clean the RT data (if necessary)
%5. identify mean RT for a single participant
%6. identify mean RT for a single participant and condition
%7. calculate condition mean RT for each participant
%8. calculate grand average RT (mean over participants) for each condition

%% 1. Load data into Matlab

%load(datafile) wont work - the 'load' function is for .mat files, but here
%we have a .csv file - we need 'readtable'

%readtable(datafile) will work, but will not assign the contents of the
%file to a particular variable in the workspace

%so instead:
data = readtable(datafile); 
%this creates a new variable called 'data' in the workspace. 
%It will be a data table containing many rows (one for every trial from
%every participant) and several columns (one for every experimental
%variable recorded on each trial)

%how do we make sense of this new variable?

%(the following bit deals with an odd issue for some files - dont worry
%about this bit)
if iscell(data.RT(1))
    rt = data.RT;
    nrt = length(rt);
    rtnum = zeros(nrt,1);
    for irt = 1:nrt
        if strcmp(rt{irt},'NA')
            rtnum(irt,1) = NaN;
        else
            rtnum(irt,1) = str2num(rt{irt});
        end
    end
    data.RT = rtnum;
end

%
%% 2. understand whats in the data and how they are organized

%one way to get a quick overview of a data table is:
head(data)
%this will show the column names, which will give you an idea of what kind
%of information might be stored there, and the first few rows of data 
%note: ths only works for data tables. for other data formats, use the
%other tricks youve practiced for getting a rough overview of your data

%% 3. find the RT data
% one of the column names was 'RT' - thats probably the reaction times.
% you can access each variable in a table using the dot operator.

meanRT = nanmean(data.RT) %calculate the average of all reaction times in the experiment (excluding entries that were NotANumber/NaN
%This is not particularly useful yet. Let's refine our approach to get the
%average RT for a single participant
%but first: getting rid of NaNs

%% 4. clean the RT data (if necessary)
meanRT = mean(data.RT) %what if we just use 'mean' instead of 'nanmean'?
%it seems that at least one trial in the dataset has RT set to NaN 
% lets find a different way of excluding the NaN trials:
trlindex = ~isnan(data.RT); %find all trials where data.RT was not NaN (~: 'not')
%this returns a variable 'trlindex' consisting of one entry for each trial
%that is either 1 (data.RT is not NaN) or 0 (data.RT is NaN)

meanRT = mean(data.RT(trlindex)) %calculate mean RT of all trials for which trlindex is equal to 1 (i.e., excluding the NaN trials)
%this should produce the same result as nanmean(data.RT)

%% 5. identify mean RT for a single participant

%let's calculate something one step closer to what we actually want: one
%participant's mean RT
% one of the other variables in the data table is 'participant' - this
% indicates the partcipant number (from 1 to 24) for each trial
trlindex = (data.participant == 1) & ~isnan(data.RT); %find all trials where participant number is 1 AND the RT is not NaN

mean(data.RT(trlindex))
%this gives us participant 1's mean RT - again, not super useful

%% 6. identify mean RT for a single participant and condition
%what we really want is the mean RT for a particular participant AND for
%all the trials matching a particular condition (e.g., only trials where
%the stimulus shape was 'snake'

trlindex = (data.participant == 1) & ~isnan(data.RT) & strcmp(data.Shape,'snake');

mean(data.RT(trlindex))
%this gives us participant 1's mean RT (after removing NaNs) only for the
%'snake' trials - more useful


%what about a particular combination of conditions?
trlindex = (data.participant == 1) & ... % adding three dots (...) indicates that the statement continues in the next line - allows you to break up long statements for readability
           ~isnan(data.RT) & ...
           strcmp(data.Shape,'snake') & ...
           data.AbsAngle==40 & ...
           strcmp(data.Face,'absent');

mean(data.RT(trlindex))
%this gives us participant 1's mean RT (after removing NaNs) only for the
%'snake' trials with no face and an absolute rotation angle of 40 degrees


%% 7. calculate condition mean RT for each participant

%unique spits out all the unique values in an array:
participantNums = unique(data.participant);

%so the length of the list of unique numbers in data.participant should give us the number of participants
nParticipants = length(participantNums); 

meanRT_byParticipant  = zeros(nParticipants,2); %create an empty array of 24 rows (nParticipants) and 2 columns (1 for each of 2 conditions - for the actual analysis we might need more columns, one for each of 10 condition combinations
for iParticipant = 1:nParticipants
    %find all trials where participant number is iParticipant AND the RT is
    %not NaN AND the stimulus shape is 'snake'
    trlindex = (data.participant == iParticipant) & ~isnan(data.RT) & strcmp(data.Shape,'snake');

    %calculate mean RT for these trials and save in row iParticipant,
    %column 1
    meanRT_byParticipant(iParticipant,1) = mean(data.RT(trlindex)); 
    
    %find all trials where participant number is iParticipant AND the RT is
    %not NaN AND the stimulus shape is 'human'
    trlindex = (data.participant == iParticipant) & ~isnan(data.RT) & strcmp(data.Shape,'human');

    %calculate mean RT for these trials and save in row iParticipant,
    %column 2
    meanRT_byParticipant(iParticipant,2) = mean(data.RT(trlindex));
end 

%% 8. calculate grand average RT (mean over participants) for each condition

%average over participants to get the group mean per condition
grandAverageRT = mean(meanRT_byParticipant,1);
grandAverageRT