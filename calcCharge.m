function  charge = calcCharge(elements,Twindow)
    if nargin == 0
        %close; 
        clear;
        %add AUImodel to the path
        setAUImodel_path();
        dat_path = '/Users/dtakeshi/Documents/Data/PrimateData/LYAPB';
        %fname = 'Elements_081809Bc2_ConditionAmes_nDat50000_Amp0_1_HoldNeg60.mat';
        fname = 'Elements_081809Bc2_ConditionLYAPB2_nDat50000_Amp0_1_HoldNeg60.mat';
        dat = load(fullfile(dat_path,fname));
        elements = dat.elements;
        Twindow = 1;%sec
    end
    dat = cellfun(@(e)e.responses.Amp_1.data,elements,'unif',0);
    [~,time,stimOn, stimOff, sampleRate] = getStimuliData(elements);
    %get baseline 
    idx = [1:length(time)]';
    preIdx =  arrayfun(@(i)time{i}>=stimOn(i)-Twindow & time{i}<stimOn(i),...
        idx,'unif',0);
    postIdx = arrayfun(@(i)time{i}>=stimOn(i) & time{i}<stimOn(i) + Twindow,...
        idx, 'unif',0);
    baseLine = cellfun(@(d,i)mean(d(i)),dat,preIdx,'unif',0);
    dataPost = cellfun(@(d,i)d(i),dat,postIdx,'unif',0);
    dataPostSubt = cellfun(@(d,b)d-b,dataPost,baseLine,'unif',0);
    dt = 1/sampleRate;
    charge = cellfun(@(d)sum(d*dt),dataPostSubt)
   
end