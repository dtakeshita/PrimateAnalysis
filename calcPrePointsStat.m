function  prePtsMean = calcPrePointsStat(elements, st,ed)
    if nargin == 0
        close; clear;
        %add AUImodel to the path
        setAUImodel_path();
        dat_path = '/Users/dtakeshi/Documents/Data/PrimateData/LYAPB';
        %fname = 'Elements_081809Bc2_ConditionAmes_nDat50000_Amp0_1_HoldNeg60.mat';
        fname = 'Elements_081809Bc2_ConditionLYAPB1_nDat50000_Amp0_1_HoldNeg60.mat';
        dat = load(fullfile(dat_path,fname));
        elements = dat.elements;
        st = 1;
        ed = 40000;
    end
    nPrePts = unique(getNumPrePoints( elements ));
    if length(nPrePts) > 2
        error('more than one nPrepts')
    end
    if ed > nPrePts
        error('ending point is not in prePts ')
    end
    prePtsMean = cellfun(@(e)mean(e.responses.Amp_1.data(st:ed)),elements);
    %startTime = getStartTime(elements);
end