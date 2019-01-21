function saveFigures( FH, baseName, save_path )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    FHnum = get(FH,'number');
    if iscell(FHnum)
        FHnum = cell2mat(FHnum);
    end
    [~,idx] = sort(FHnum);
    FH = FH(idx);
    if ~exist(save_path,'dir')
        mkdir(save_path);
    end
    nFig = length(FH);
    if nFig == 1
        saveas(FH,fullfile(save_path,sprintf('%s.bmp',baseName)));
        return
    end
    for nf = 1:nFig
        saveas(FH(nf),fullfile(save_path,sprintf('%s_%d.bmp',baseName,nf)))
    end
end

