function  [M, V] = calcHoldingCurrentStat(elements,st, ed)
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
    dat0 = cellfun(@(e)e.responses.Amp_1.data,elements,'unif',0);
    dat = cellfun(@(d)d(st:ed),dat0,'unif',0);
    M = cellfun(@mean, dat);
    V = cellfun(@var, dat);
    if nargin == 0
        figure;
        X = 1:length(M);
        [AX,H1,H2] = plotyy(X,M,X,V);
        title(fname,'interpreter','none')
    end
end