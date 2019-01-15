close; clear;
%add AUImodel to the path
setAUImodel_path();

%dat_path = '/Users/dtakeshi/Documents/Data/PrimateData/LYAPB';
dat_path = '/Volumes/PALHD23/primateData/LYAPB';
%fname = 'Elements_081809Bc2_ConditionAmes_nDat50000_Amp0_1_HoldNeg60.mat';
%fname = 'Elements_081809Bc2_ConditionLYAPB1_nDat50000_Amp0_1_HoldNeg60.mat';
fname = 'Elements_091609Fc1_ConditionAmes_nDat75000_Amp0_24_HoldNeg60.mat';

dat = load(fullfile(dat_path,fname));
elements = dat.elements;
nEpochs = length(elements);
figure;
for ne=1:nEpochs
    recDuration = elements{ne}.duration;%in sec
    str_time = sprintf('%d-%d-%d %d:%d:%2.0f',elements{ne}.startDate);
    data = elements{ne}.responses.Amp_1.data;
    ndat = length(data);
    fs = ndat/recDuration;
    T = [0:(ndat-1)]/fs;
    plot(T,data)
    title(str_time)
end
