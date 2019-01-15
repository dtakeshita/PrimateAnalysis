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
        
        [psd, F] = calcPowerSpec(elements, Fs, st,ed);
        
        ndat = 65000;
        Amp = '0_73';
        cond_ames = 'Ames';
        cond_lyapb = 'LYAPB1';
        fname_Ames = sprintf('Elements_%s_Condition%s_nDat%d_Amp%s_HoldNeg60.mat',...
            cname,cond_ames,ndat,Amp);
        fname_lyapb = sprintf('Elements_%s_Condition%s_nDat%d_Amp%s_HoldNeg60.mat',...
            cname,cond_lyapb,ndat,Amp);
        elements_ames = loadElements(fname_Ames,dat_path);
        elements_lyapb = loadElements(fname_lyapb,dat_path);
        [psd_ames, F_ames] = calcPowerSpec(elements_ames, Fs, st,ed);
        [psd_lyapb, F_lyapb] = calcPowerSpec(elements_lyapb, Fs, st,ed);

        figure;
        h_ames = loglog(F_ames{1},psd_ames{1},'k');
        hold on
        h_ly = loglog(F_lyapb{end},psd_lyapb{end},'r');
        title(cname)
        legend([h_ames h_ly],{cond_ames,cond_lyapb})
        xlabel('Frequency (Hz)');ylabel('PSD')
        set(gca,'fontsize',20)
        set([h_ames h_ly],'linewidth',lw);
    end
end


