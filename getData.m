function  dat = getData(elements,varargin)
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
    st = 1;
    if nargin >= 2
       st = varargin{1}; 
    end
    if nargin >= 3
        ed = varargin{2};
    end
    dat = cellfun(@(e)e.responses.Amp_1.data,elements,'unif',0);
    if exist('ed','var');
        dat = cellfun(@(d)d(st:ed),dat,'unif',0);
    end
    if nargin == 0
        figure;
        X = 1:length(M);
        [AX,H1,H2] = plotyy(X,M,X,V);
        title(fname,'interpreter','none')
    end
end