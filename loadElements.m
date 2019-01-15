function elements = loadElements(fname,varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    dat_path = '/Users/dtakeshi/Documents/Data/PrimateData/LYAPB';
    if nargin == 0
       fname = 'Elements_081809Bc2_ConditionAmes_nDat50000_Amp0_1_HoldNeg60.mat'; 
    end
    if nargin >=2
        dat_path = varargin{1};
    end
    dat = load(fullfile(dat_path,fname));
    elements = dat.elements;
end

