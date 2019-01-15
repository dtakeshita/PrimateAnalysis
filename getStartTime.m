function t = getStartTime( elements )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
    v = cellfun(@(e)e.startDate,elements,'unif',0);
    t = cellfun(@datetime,v,'unif',0);
    t = [t{:}]';
end

