function  [stimData,time, stimOnset, stimOffset, sampleRate] = getStimuliData(elements)
    if nargin == 0
        %close; 
        clear;
        %add AUImodel to the path
        setAUImodel_path();
        dat_path = '/Users/dtakeshi/Documents/Data/PrimateData/LYAPB';
        fname = 'Elements_081809Bc2_ConditionAmes_nDat50000_Amp0_1_HoldNeg60.mat';
        %fname = 'Elements_081809Bc2_ConditionLYAPB2_nDat50000_Amp0_1_HoldNeg60.mat';
        dat = load(fullfile(dat_path,fname));
        elements = dat.elements;
        st = 1;
        ed = 40000;
    end
    stim = cellfun(@(d)d.stimuli,elements,'unif',0);
    stimSource = cellfun(@(d)fieldnames(d),stim,'unif',0);
    nStimSource = cellfun(@length, stimSource);
    if max(nStimSource) > 1
        error('more than 1 stim sources - code may need to be modified')
    end
    %s = cellfun(@(s)stim{i}.(s),stimSource{i},'unif',0);
    sampleRate = arrayfun(@(i)cellfun(@(s)stim{i}.(s).sampleRate,stimSource{i},'unif',0),1:length(stimSource),'unif',0);
    sampleRate = unique(cellfun(@cell2mat,sampleRate));
    if length(sampleRate) > 1
        error('more than 1 sample rate')
    end
    stimData = arrayfun(@(i)cellfun(@(s)stim{i}.(s).data,stimSource{i},'unif',0),1:length(stimSource),'unif',0);
    stimData = cellfun(@cell2mat, stimData,'unif',0);
    stimOnsetIndex = cellfun(@(s)find(s>eps,1,'first'),stimData,'unif',0);
    stimOffsetIndex = cellfun(@(s)find(s>eps,1,'last')+1,stimData,'unif',0);
    nData = cellfun(@length, stimData,'unif',0);
    timeIndex = cellfun(@(nd,stim)[1:nd]-stim,nData,stimOnsetIndex,'unif',0);
    time = cellfun(@(I)I/sampleRate,timeIndex,'unif',0);
    stimOnset = cellfun(@(t,i)t(i),time,stimOnsetIndex);
    stimOffset = cellfun(@(t,i)t(i),time,stimOffsetIndex);
    if nargin == 0
        figure;
        plot(time{1}, stimData{1},'x-')
        hold on
        plot(stimOnset(1)*[1 1], [0 max(stimData{1})],'--')
        plot(stimOffset(1)*[1 1], [0 max(stimData{1})],'--')
    end
end