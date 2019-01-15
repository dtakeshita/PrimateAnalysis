function out = getNumPrePoints( elements )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes her
    if iscell(elements)
        out = cellfun(@(e)e.stimuli.Blue_LED.parameters.prepts,elements);
    else
        out = elements.stimuli.Blue_LED.parameters.prepts;
    end
end

