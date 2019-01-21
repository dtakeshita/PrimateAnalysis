function figOffset = getFigureOffset()
%Returns the maximum number of existing figure 
    FH = findobj(0,'type','figure');
    figOffset = 0;
    if ~isempty(FH)
        FH = get(FH,'Number');
        if iscell(FH)
            FH = cell2mat(FH);
        end
        figOffset = max(FH);
    end

end

