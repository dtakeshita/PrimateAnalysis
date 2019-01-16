clear; close;
%% paths
list_path = '/Users/dtakeshi/Dropbox/AlaLaurila-Lab-Yoda/Patch rig/CellList';
    
lw = 2;
st = 1; ed = 40000;
Fs = 10000;
setAUImodel_path();
%dat_path = '/Volumes/PALHD23/primateData/LYAPB';
dat_path = '/Users/dtakeshi/Documents/Data/PrimateData/LYAPB';


[props, keys] = load_celllist('Primate*LYAPB', list_path);
cellNames = props('CellName');
conditions = props('Condition');
doAnalysis = cellfun(@(p)strcmpi(p,'x'),props('Analyze'));
hasCellName = cellfun(@ischar,cellNames);
idx = [find(hasCellName);length(hasCellName)+1];
idxPerCell = arrayfun(@(i)idx(i):idx(i+1)-1,1:length(idx)-1,'unif',0);
nCells = length(idxPerCell);
for nc=1:nCells
    cname = cellNames{idxPerCell{nc}};
    indices = idxPerCell{nc};
    figure;
    for ni = 1:length(indices)
        if ~doAnalysis(indices(ni))
            continue;
        end
        condition = conditions{indices(ni)};
        %str_file = sprintf('Elements_%s*.mat', cname);
        str_file = sprintf('Elements_%s_Condition%s*.mat', cname, condition);
        files = dir(fullfile(dat_path, str_file));
        nfiles = length(files);
        if length(nfiles)>1
           error('More than one file for a single condition'); 
        end
        elements = loadElements(files(1).name,dat_path);
        dat = getData(elements);
        [~,t,stimOn, stimOff] = getStimuliData(elements);
        %% to-do: plot responses as a function of epochs
        %calcCharge(elements);
        %% to-do: plot holding current
        
        %% plot responses
        ndat = length(dat);
        nfigrw = 3; nfigcl = 5;
        nfigall = nfigrw*nfigcl;
        for nd =1:ndat
            nfig = ceil(nd/nfigall);
            figure(nfig)
            nax = nd-nfigall*(nfig-1);
            subplot(nfigrw,nfigcl,nax)
            plot(t{nd},dat{nd})
            str_ttl = sprintf('%s %s e%d',cname, condition, nd);
            title(str_ttl)
            set(gca,'xlim',[t{nd}(1) t{nd}(end)])
        end
        
       
    end
end


