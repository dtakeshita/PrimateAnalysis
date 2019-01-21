function FH = plotRawData( baseName, elements, nrow, ncol, figOffset )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    dat = getData(elements);
    [~,time] = getStimuliData(elements);
    nElements = length(elements);
    nAxesPerFig = nrow*ncol;
    FH = gobjects();
    for n = 1:nElements
        figID = ceil(n/nAxesPerFig);
        axID = n - nAxesPerFig*(figID-1);
        FH(n) = figure(figID+figOffset);
        subplot(nrow,ncol,axID)
        plot(time{n},dat{n})
        str_ttl = {baseName;sprintf('element %d',n)};
        set(gca,'xlim',[time{n}(1) time{n}(end)])
        title(str_ttl)
        xlabel('Time (sec)');ylabel('Current (pA)');
        set(gca,'fontsize',12)
    end
    FH = unique(FH);
end

